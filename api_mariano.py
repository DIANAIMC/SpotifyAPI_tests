import requests
import time
from pymongo import MongoClient

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

print('Obteniendo artistas')
artistas = []
for year in range(2020,2022):
   artistas = get_data(ACCESS_TOKEN, artistas, 1000, year, 'artist')
print(len(artistas))

print('\nObteniendo albums')
albums = []
for year in range(2020,2022):
   albums = get_data(ACCESS_TOKEN, albums, 1000, year, 'album')
print(len(albums))

print('\nObteniendo tracks')
tracks = []
for year in range(2020,2022):
   tracks = get_data(ACCESS_TOKEN, tracks, 1000, year, 'track')
print(len(tracks))