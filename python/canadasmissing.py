import requests
import json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from datetime import datetime

'''
canadasmissing.py

This script retrieves data used by https://www.canadasmissing.ca/index-eng.htm, by accessing the json script used to
populate the page. This is used to retrieve real data for use in the application.
'''

cred = credentials.Certificate('pythonServiceAccountKey.json')
firebase_admin.initialize_app(cred)

db = firestore.client()
ref = db.collection(u'persons')

response = requests.get("https://www.services.rcmp-grc.gc.ca/missing-disparus/cases-en.json?cases=20")
print(response.status_code)

data = json.loads(response.content)
persons = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20} #will store the data to insert

for person in data["content"]:
    
    record = {
        'id': int(person['id']),
        'firstName': (person['title'].split(",",1)[1])[1:],
        'lastName': person['title'].split(",",1)[0],
        'image': 'https://www.services.rcmp-grc.gc.ca' + person['image'],
        'missingSince': datetime.strptime(person['missingSince'], '%Y-%m-%d'),
        'city': person['city'],
        'province': (person['province'])[:2]
    }

    for key in record:
        print("%s: %s" %(key, record[key]))

    ref.add(record)