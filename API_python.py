import requests
import time
from pymongo import MongoClient
from iteration_utilities import unique_everseen

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
    artist = []
    album = []
    track = []
    for anio in range(2020,2023):
        artist.extend(get_artist(ACCESS_TOKEN,size,anio))
        album.extend(get_album(ACCESS_TOKEN,size,anio))
        track.extend(get_track(ACCESS_TOKEN,size,anio))
    artist_final = list(unique_everseen(artist))
    album_final = list(unique_everseen(album))
    track_final = list(unique_everseen(track))
    fin = time.time()
    print(f"Ejecución del programa en minutos: {(fin-inicio)/60} \nTamaños de: \nArtistas {len(artist)}, {len(artist_final)} \nAlbums {len(album)},{len(album_final)} \nTrack {len(track)}, {len(track_final)}")
        
        

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
