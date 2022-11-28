import requests

#Credenciales de Spotify
CLIENT_ID = 'af1707ed062448f9aa96ffd1b36737ac'
CLIENT_SECRET = '017e9f625cc149b8b1e11c69bd21ef1d'
#Token de autenticación para el GET
ACCESS_TOKEN = 'BQCRhrP7ri9VTAsnLMrYn1SEuqHJvaI3KC8hsYBQEP0_jc_zTAKncfMaiqlntylT1IW9QoynbnQT8kFV_uVou0YY-ucI2_i_8T4qOOXw3iaPvFaW2g1Cun94mWXwQg7Acq-N0gTTNfyYfBoqfsWlASKfFyoLOCpTl-Tty71_VQ5cHRJMQl4UY7PFGz-mE1LXdd0'

"""
    Este método nos permite extraer artistas de Spotify (aquellos que contienen una A) de 1 en 1 hasta el "total" y los agrega a la lista "artist" la cual posteriormente usaremos
    para insertar los asrtistas en Mongo.
    Input:
        access_token: Autenticación necesaria para el request
        total: cantidad de artistas que queremos extraer. Nota: solo hay aproximadamente 10,000 artistas
"""
def get_artist1(access_token,total):
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
        #Solo extraemos información relevante del artista
        artist_id = json_resp["artists"]['items'][0]['id']
        artist_name = json_resp["artists"]['items'][0]['name']
        genres = json_resp["artists"]['items'][0]['genres']
        followers = json_resp["artists"]['items'][0]['followers']
        popularity = json_resp["artists"]['items'][0]['popularity']
        url = json_resp["artists"]['items'][0]['external_urls']
        current_artist_info = {
            "id": artist_id,
            "name": artist_name,
            "genres": genres,
            "followers": followers,
            "popularity": popularity,
            "url": url
        }
        artists.append(current_artist_info)
        offset += 1
    return artists

inicio = time.time()
print((get_artist1(ACCESS_TOKEN,200)))
fin = time.time()
print("Ejecución del programa en minutos: ", (fin-inicio)/60)
