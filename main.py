import requests
import csv
import json
import os
from datetime import datetime


def main():
    os.makedirs("raw-data", exist_ok=True)
    with open("./seeds/dim_city.csv", newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            lat = row['latitude']
            lon = row['longitude']
            city = row['city'].replace(' ', '_')
            url = f"https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&hourly=temperature_2m"
            resp = requests.get(url)
            filename = f"raw-data/weather_{city.lower()}_{datetime.now():%Y%m%d%H%M%S}.json"
            with open(filename, "w", encoding='utf-8') as f:
                json.dump(resp.json(), f, indent=2)


if __name__ == "__main__":
    main()
