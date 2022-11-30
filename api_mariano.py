import requests
import time
from pymongo import MongoClient
from iteration_utilities import unique_everseen

ACCESS_TOKEN = 'BQA4xzbXSIP_yIpiZ6aXxE9VHKd0cZszTJr_mSZsy5wVkdD7Hcud8_dSnakjhISx_F8FYEitly-AVKZRtsh6P8sIzgEJrV69ylX5ONp8bZxwVIMRZ2GN78rWBvoQ0WPO0BH1rHlXcz6FOKO168O42t9__ljjIpmlIsl9yJoJvFE_9rko'

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

anio_inicio = 2020
anio_fin = 2023

print('Obteniendo artistas')
artistas = []
for year in range(anio_inicio, anio_fin):
   print(f'Año {year}')
   artistas = get_data(ACCESS_TOKEN, artistas, 1000, year, 'artist')
# Limpiamos los artistas para que no haya repetidos
artistas_final = list(unique_everseen(artistas))
print(f'Previo a limpieza: {len(artistas)}')
print(f'Posterior a limpieza: {len(artistas_final)}')

print('\nObteniendo albums')
albums = []
for year in range(anio_inicio, anio_fin):
   print(f'Año {year}')
   albums = get_data(ACCESS_TOKEN, albums, 1000, year, 'album')
# Limpiamos los albums para que no haya repetidos
albums_final = list(unique_everseen(albums))
print(f'Previo a limpieza: {len(albums)}')
print(f'Posterior a limpieza: {len(albums_final)}')

print('\nObteniendo tracks')
tracks = []
for year in range(anio_inicio, anio_fin):
   print(f'Año {year}')
   tracks = get_data(ACCESS_TOKEN, tracks, 1000, year, 'track')
# Limpiamos los tracks para que no haya repetidos
tracks_final = list(unique_everseen(tracks))
print(f'Previo a limpieza: {len(tracks)}')
print(f'Posterior a limpieza: {len(tracks_final)}')