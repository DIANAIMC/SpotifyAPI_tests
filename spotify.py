# coding: utf-8

import requests
import datetime
import base64
import time

from pymongo import MongoClient
from iteration_utilities import unique_everseen

'''
get_access_token(client_id, client_secret, token_url)
'''
def get_access_token(client_id, client_secret, token_url):
    token_data = {"grant_type": "client_credentials"}
    creds = f"{client_id}:{client_secret}"
    creds_b64 = base64.b64encode(creds.encode())
    token_headers = {"Authorization": f"Basic {creds_b64.decode()}"}

    r = requests.post(token_url, data=token_data, headers=token_headers)
    if r.status_code not in range(200, 299):
        raise Exception("Could not authenticate client.")

    data = r.json()
    now = datetime.datetime.now()
    access_token = data['access_token']
    return access_token

'''
get_data(access_token, lista, limite, year, type)

acces_token: token de acceso a api
lista: lista en la que se desea agregar los datos
limite: offset máximo
year: año del que se desea extraer los datos
type: tipo de dato a extraer (artist, album, track)
'''
def get_data(access_token, lista, limite, year, type):
    offset = 0
    for _ in range(round(limite/50)):
        response = requests.get(
         f'https://api.spotify.com/v1/search?q=year%3A{year}&type={type}&limit=50&offset={offset}',
            headers={
                "Authorization": f"Bearer {access_token}",
                'Content-Type': 'application/json'
            }
        )
        json_resp = response.json()
        tipo_aux = f"{type}s"
        if tipo_aux in list(json_resp.keys()):
            current_data = json_resp[tipo_aux]['items']
            lista.extend(current_data)
            offset += 50
        else:
            break
    return lista

client_id = 'af1707ed062448f9aa96ffd1b36737ac'
client_secret = '017e9f625cc149b8b1e11c69bd21ef1d'
token_url = "https://accounts.spotify.com/api/token"

access_token = get_access_token(client_id, client_secret, token_url)

anio_inicio = 2020
anio_fin = 2021

inicio = time.time()

print('Obteniendo artistas…')
artistas = []
for year in range(anio_inicio, anio_fin):
    print(f'\tAño {year}')
    artistas = get_data(access_token, artistas, 1000, year, 'artist')
# Limpiamos los artistas para que no haya repetidos
artistas_final = list(unique_everseen(artistas))
print(f'Artistas encontrados previo a limpieza: {len(artistas)}')
print(f'Posterior a limpieza: {len(artistas_final)}')

print('\nObteniendo albums…')
albums = []
for year in range(anio_inicio, anio_fin):
    print(f'\tAño {year}')
    albums = get_data(access_token, albums, 1000, year, 'album')
# Limpiamos los albums para que no haya repetidos
albums_final = list(unique_everseen(albums))
print(f'Albums encontrados previo a limpieza: {len(albums)}')
print(f'Posterior a limpieza: {len(albums_final)}')

print('\nObteniendo tracks…')
tracks = []
for year in range(anio_inicio, anio_fin):
    print(f'\tAño {year}')
    tracks = get_data(access_token, tracks, 1000, year, 'track')
# Limpiamos los tracks para que no haya repetidos
tracks_final = list(unique_everseen(tracks))
print(f'Tracks encontrados previo a limpieza: {len(tracks)}')
print(f'Posterior a limpieza: {len(tracks_final)}')

fin = time.time()
# print(f"\nEjecución del programa en minutos: {(fin-inicio)/60}")


"""
    INCERSIÓN DE DATOS A MONGO
"""
print('\n-------------------INSERTAMOS DATOS A MONGO----------------------')
# Inicializamos MongoClient
client = MongoClient()
# Indicamos el servidor
client = MongoClient('localhost',27017)
my_database = client.spotify
my_collection1 = my_database.artists
my_collection2 = my_database.albums
my_collection3 = my_database.tracks
print('Insertamos artistas\n')
my_collection1.insert_many(artistas_final)
print('Insertamos albums\n')
my_collection2.insert_many(albums_final)
print('Insertamos tracks\n')
my_collection3.insert_many(tracks_final)