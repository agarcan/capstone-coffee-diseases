from datetime import datetime, timedelta
import requests
from geopy.geocoders import Nominatim
import numpy as np
import os

api_key = os.environ["API_KEY"]

geolocator = Nominatim(user_agent="capstone-project-aws")


def _get_lat_lon_coords(location: str) -> tuple[float, float]:
    location = geolocator.geocode(location)
    return location.latitude, location.longitude


def fetch_weather_data(location):

    url = "https://api.openweathermap.org/data/2.5/onecall/timemachine"

    lat, lon = _get_lat_lon_coords(location)

    picture_date = datetime.now()
    weather_date = picture_date - timedelta(days=1)
    timestamp = round(datetime.timestamp(weather_date))
    params = {
        "lat": str(lat),
        "lon": str(lon),
        "units": "metric",
        "dt": timestamp,
        "appid": api_key,
    }

    result = requests.get(url=url, params=params)
    return result.json(), picture_date


def collect_weather_records(weather_data):
    temps = []
    humidity = []
    clouds = []
    pressure = []

    for record in weather_data["hourly"]:
        temps.append(record["temp"])
        humidity.append(record["humidity"])
        clouds.append(record["clouds"])
        pressure.append(record["pressure"])
    return temps, humidity, clouds, pressure


def weather_indexes(location, tbase_cdd=21, tbase_hdd=18):

    weather_data, picture_date = fetch_weather_data(location=location)
    
    (temps, humidity, clouds, pressure) = collect_weather_records(
        weather_data=weather_data
    )

    tmean = np.mean(temps)
    tmin = np.min(temps)
    tmax = np.max(temps)
    Hmean = np.mean(humidity)
    Pmean = np.mean(pressure)

    hdd = (lambda x: tbase_hdd - x if x < tbase_hdd else 0)((tmin + tmax) * 0.5)
    cdd = (lambda x: x - tbase_cdd if x > tbase_cdd else 0)((tmin + tmax) * 0.5)

    return (
        {
            "tmean": str(round(tmean, 2)),
            "tmin": str(round(tmin, 2)),
            "tmax": str(round(tmax, 2)),
            "Hmean": str(round(Hmean, 2)),
            "Pmean": str(round(Pmean, 2)),
            "cdd": str(round(cdd, 2)),
            "hdd": str(round(hdd, 2)),
        },
        str(picture_date).split(" ")[0],
    )
