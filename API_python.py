import requests
import time
from pymongo import MongoClient

"""
    EXTRACCIÓN DE DATOS A PARTIR DE UNA API

"""

ACCESS_TOKEN = 'BQDcOzPmFNy9k5-jIvMZVTDOi5MFwo7XHI5mUCzV-RUfUjYoh2UIInfRFcqL6zKElF-6A8XVW5DvRFDewOYjr9wP0PNvp0_V2LwJfShgWV-_5VF3TW9F_NHo5SpUz9yH_BQjAOz3qWNwEaxcujXAuzHEvgCcVN3vPSCb95Ih2k4uSEwXkZUwyoJmi2V1S7ibYg4'
def get_artist(access_token,total,anio):
    artists = []
    offset=0
    limit=50
    for i in range(round(total/50)):
        response = requests.get(
            f'https://api.spotify.com/v1/search?q=year%3A{anio}&type=artist&limit={limit}&offset={offset}',
            headers={
                "Authorization": f"Bearer {access_token}",
                'Content-Type': 'application/json'
            }
        )
        json_resp = response.json()
        if "artists" in list(json_resp.keys()):
            current_artist_info = json_resp["artists"]['items']
            artists.extend(current_artist_info)
            offset += 50
        else:
            break
    return artists

def get_album(access_token,total,anio):
    albums = []
    offset=0
    limit=50
    for i in range(round(total/50)):
        response = requests.get(
            f'https://api.spotify.com/v1/search?q=year%3A{anio}&type=album&limit={limit}&offset={offset}',
            headers={
                "Authorization": f"Bearer {access_token}",
                'Content-Type': 'application/json'
            }
        )
        json_resp = response.json()
        if "albums" in list(json_resp.keys()):
            current_album_info = json_resp["albums"]["items"]
            albums.extend(current_album_info)
            offset += 50
        else:
            break
    return albums

def get_track(access_token,total,anio):
    tracks = []
    offset=0
    limit=50
    for i in range(round(total/50)):
        response = requests.get(
            f'https://api.spotify.com/v1/search?q=year%3A{anio}&type=track&limit={limit}&offset={offset}',
            headers={
                "Authorization": f"Bearer {access_token}",
                'Content-Type': 'application/json'
            }
        )
        json_resp = response.json()
        if "tracks" in list(json_resp.keys()):
            current_track_info = json_resp["tracks"]["items"]
            tracks.extend(current_track_info)
            offset += 50
        else:
            break
    return tracks

def extrae_api(size=1000):
    inicio = time.time()
    for anio in range(1990,2023):
        artist = get_artist(ACCESS_TOKEN,size,anio)
        album = get_album(ACCESS_TOKEN,size,anio)
        track = get_track(ACCESS_TOKEN,size,anio)
    fin = time.time()
    print(f"Ejecución del programa en minutos: {(fin-inicio)/60} \nTamaños de: \nArtistas {len(artist)} \nAlbums {len(album)} \nTrack {len(track)}")
        

"""
    INCERSIÓN DE DATOS A MONGO

"""

"""
# Inicializamos MongoClient
client = MongoClient()
# Indicamos el servidor (este es el casi siempre se usa)
client = MongoClient('localhost',27017)
# NOTA: También se puede escribir de la siguiente manera
# client = MongoClient('mongodb://0.0.0.0:27017')
# Los ceros indica que acceda a la propia computadora. Incluso puede llegar a convenir más.

mydatabase = client.spotify_proyecto
mycollection1 = mydatabase.artists
mycollection2 = mydatabase.albums
mycollection3 = mydatabase.tracks

mycollection1.insert_many(artist)
mycollection2.insert_many(album)
mycollection3.insert_many(track)
"""
