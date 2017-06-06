
import pynder
import json

# lê id e senha da entrada padrão
facebook_id = input()
facebook_token = input()

# loga
session = pynder.Session(facebook_id = facebook_id,
                         facebook_token = facebook_token)

# pega o posicionamento atual
lat = session.profile._data['pos']['lat']
lng = session.profile._data['pos']['lon']

data = dict()
data['pos1'] = [lat, lng]
data['pos2'] = [lat - .25, lng - .25]
data['pos3'] = [lat - .25, lng]
data['matches'] = []

# varre os matches coletando infos e distâncias ao ponto atual
for match in session.matches():
    photos = match.user.get_photos()
    picture = photos[0] if (len(photos) > 0) else "egg.png"

    data['matches'].append({
        'name': match.user.name,
        'picture': picture,
        'last_online': match.user.ping_time,
        'dist1': match.user.distance_km
    })

# segunda medição: atualiza a posição e pega as novas distâncias
session.update_location(lat - .25, lng - .25)

i = 0
for match in session.matches():
    data['matches'][i]['dist2'] = match.user.distance_km
    i += 1

# terceira medição: atualiza a posição e pega as novas distâncias
session.update_location(lat - .25, lng)

i = 0
for match in session.matches():
    data['matches'][i]['dist3'] = match.user.distance_km
    i += 1

# joga os dados coletados na saída padrão
print(json.dumps(data))
