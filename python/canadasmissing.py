import requests
import json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
#from bs4 import BeautifulSoup

cred = creditials.ApplicationDefault()
firebase_admin.initialize_app

response = requests.get("https://www.services.rcmp-grc.gc.ca/missing-disparus/cases-en.json?cases=20")
print(response.status_code)

data = json.loads(response.content)
persons = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20} #will store the data to insert

for person in data["content"]: #.items()
    #print("\nPerson ID:", data_id)

    for key in person:
        print("%s: %s" %(key, person[key]))
        #TODO: pull title, city, province, missingSince

input() #pauses to prevent program from closing right away