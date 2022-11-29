import requests
import time

"""
    EXTRACCIÓN DE DATOS A PARTIR DE UNA API

"""

#Token de autenticación para los GET. Nota: Hay que automatizar generar un token en cada ejecución porque los tokens caducan después de cierto tiempo 
# y tenemos que andarlo cambiando manualmente.
ACCESS_TOKEN = 'BQCRhrP7ri9VTAsnLMrYn1SEuqHJvaI3KC8hsYBQEP0_jc_zTAKncfMaiqlntylT1IW9QoynbnQT8kFV_uVou0YY-ucI2_i_8T4qOOXw3iaPvFaW2g1Cun94mWXwQg7Acq-N0gTTNfyYfBoqfsWlASKfFyoLOCpTl-Tty71_VQ5cHRJMQl4UY7PFGz-mE1LXdd0'

"""
    En los siguientes métodos extraemos artistas, canciones y albumes de Spotify (aquellos que contienen una A) de 1 en 1 hasta el "total" y los agrega a la lista con su nombre, posteriormente usaremos
    dichas listas para insertar los datos en Mongo.
    Input:
        access_token: Autenticación necesaria para el request
        total: cantidad de artistas que queremos extraer. Nota: solo hay aproximadamente 10,000 artistas
"""
def get_artist(access_token,total):
    artists = []
    offset=0
    limit=1
    for i in range(total):
        response = requests.get(
            f'https://api.spotify.com/v1/search?q=A&type=artist&limit={limit}&offset={offset}',
            headers={
                "Authorization": f"Bearer {access_token}",
                'Content-Type': 'application/json'
            }
        )
        json_resp = response.json()
        current_artist_info = json_resp["artists"]['items'][0]
        del current_artist_info["images"]
        artists.append(current_artist_info)
        offset += 1
    return artists

def get_album(access_token,total):
    albums = []
    offset=0
    limit=1
    for i in range(total):
        response = requests.get(
            f'https://api.spotify.com/v1/search?q=A&type=album&limit={limit}&offset={offset}',
            headers={
                "Authorization": f"Bearer {access_token}",
                'Content-Type': 'application/json'
            }
        )
        json_resp = response.json()
        current_album_info = json_resp["albums"]["items"][0]
        del current_album_info["images"]
        albums.append(current_album_info)
        offset += 1
    return albums

def get_track(access_token,total):
    tracks = []
    offset=0
    limit=1
    for i in range(total):
        response = requests.get(
            f'https://api.spotify.com/v1/search?q=A&type=track&limit={limit}&offset={offset}',
            headers={
                "Authorization": f"Bearer {access_token}",
                'Content-Type': 'application/json'
            }
        )
        json_resp = response.json()
        current_track_info = json_resp["tracks"]["items"][0]
        del current_track_info["album"]["images"]
        tracks.append(current_track_info)
        offset += 1
    return tracks


inicio = time.time()

size = 500
artist = get_artist(ACCESS_TOKEN,size)
album = get_album(ACCESS_TOKEN,size)
track = get_track(ACCESS_TOKEN,size)

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

fin = time.time()
print("Ejecución del programa en minutos: ", (fin-inicio)/60)

# Referencia: https://github.com/imdadahad/spotify-get-current-playing-track/blob/master/main.py
