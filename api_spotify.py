#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import requests
import datetime
import pymongo
import base64
import time
import json

from pymongo import MongoClient
from iteration_utilities import unique_everseen
from urllib.parse import urlencode

class Spotify_Authorization(object):
    client_id = 'af1707ed062448f9aa96ffd1b36737ac'
    client_secret = '017e9f625cc149b8b1e11c69bd21ef1d'
    token_url = "https://accounts.spotify.com/api/token"
    access_token = None
    access_token_expires = datetime.datetime.now()
    access_token_did_expire = True
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def get_credentials(self):
        """
        Returns a base64 encoded string
        """
        creds = f"{self.client_id}:{self.client_secret}"
        creds_b64 = base64.b64encode(creds.encode())
        return creds_b64.decode()
    
    def perform_auth(self):
        token_data = {"grant_type": "client_credentials"}
        creds_b64 = self.get_credentials()
        token_headers = {"Authorization": f"Basic {creds_b64}"}
        
        r = requests.post(self.token_url, data=token_data, headers=token_headers)
        if r.status_code not in range(200, 299):
            raise Exception("Could not authenticate client.")
        
        data = r.json()
        now = datetime.datetime.now()
        access_token = data['access_token']
        expires_in = data['expires_in'] # seconds
        expires = now + datetime.timedelta(seconds=expires_in)
        self.access_token = access_token
        self.access_token_expires = expires
        self.access_token_did_expire = expires < now
        return True
    
    def get_access_token(self):
        token = self.access_token
        expires = self.access_token_expires
        now = datetime.datetime.now()
        if (token == None) or (expires < now):
            self.perform_auth()
            return self.get_access_token()
        return token

spotify = Spotify_Authorization()

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

access_token = spotify.get_access_token()

anio_inicio = 2020
anio_fin = 2023

inicio = time.time()

print('Obteniendo artistas…')
artistas = []
for year in range(anio_inicio, anio_fin):
    print(f'\tAño {year}')
    artistas = get_data(access_token, artistas, 1000, year, 'artist')
# Limpiamos los artistas para que no haya repetidos
artistas_final = list(unique_everseen(artistas))
print(f'Previo a limpieza: {len(artistas)}')
print(f'Posterior a limpieza: {len(artistas_final)}')

print('\nObteniendo albums…')
albums = []
for year in range(anio_inicio, anio_fin):
    print(f'\tAño {year}')
    albums = get_data(access_token, albums, 1000, year, 'album')
# Limpiamos los albums para que no haya repetidos
albums_final = list(unique_everseen(albums))
print(f'Previo a limpieza: {len(albums)}')
print(f'Posterior a limpieza: {len(albums_final)}')

print('\nObteniendo tracks…')
tracks = []
for year in range(anio_inicio, anio_fin):
    print(f'\tAño {year}')
    tracks = get_data(access_token, tracks, 1000, year, 'track')
# Limpiamos los tracks para que no haya repetidos
tracks_final = list(unique_everseen(tracks))
print(f'Previo a limpieza: {len(tracks)}')
print(f'Posterior a limpieza: {len(tracks_final)}')

fin = time.time()
print(f"\nEjecución del programa en minutos: {(fin-inicio)/60}")


"""
    INCERSIÓN DE DATOS A MONGO
"""
"""
# Inicializamos MongoClient
client = MongoClient()
# Indicamos el servidor
client = MongoClient('localhost',27017)
mydatabase = client.spotify
mycollection1 = mydatabase.artists
mycollection2 = mydatabase.albums
mycollection3 = mydatabase.tracks
mycollection1.insert_many(artistas_final)
mycollection2.insert_many(albums_final)
mycollection3.insert_many(tracks_final)
"""

