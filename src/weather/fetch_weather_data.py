from geopy.geocoders import Nominatim
from meteostat import Point, Daily
import numpy as np

from datetime import datetime
from dateutil.relativedelta import relativedelta
import requests

geolocator = Nominatim(user_agent="capstone-project-aws")


def convert_string_dates_to_array(date_str):
    return np.array(date_str.split("_"), int)


def get_time_range(date_array):
    end_time = set_datetime(*date_array)
    init_time = set_datetime(*date_array) - relativedelta(months=1)
    return init_time, end_time


def set_datetime(year, month, day):
    return datetime(year, month, day)


def fetch_weather_station(lon, lat, alt):
    return Point(lon, lat, alt)


def extract_data_slices(weather_data, start, end):
    return Daily(weather_data, start, end).fetch()


def get_elevation_data(lat, lon):
    url = "https://api.opentopodata.org/v1/srtm90m"
    query = {
        "locations": f"{lat}, {lon}",
        "interpolation": "cubic",
    }
    response = requests.post(url, json=query)
    return eval(response.content)["results"][0]["elevation"]


def get_lan_lon_coords(location):
    location = geolocator.geocode(location)
    return location.latitude, location.longitude


def get_weather_for_address(location):

    lat, lon = get_lan_lon_coords(location)
    alt = get_elevation_data(lat, lon)

    return fetch_weather_station(lat, lon, alt)


def get_weather_indexes(weather_data, tbase_hdd, tbase_cdd):
    tmp_data = weather_data.copy()
    tmp_data["mean"] = (tmp_data["tmin"] + tmp_data["tmax"]) * 0.5
    tmp_data["hdd"] = tmp_data["mean"].apply(
        lambda x: tbase_hdd - x if x < tbase_hdd else 0
    )
    tmp_data["cdd"] = tmp_data["mean"].apply(
        lambda x: x - tbase_cdd if x > tbase_hdd else 0
    )
    return tmp_data.loc[:, ["mean", "tmin", "tmax", "hdd", "cdd", "prcp"]]


def weather_indexes(location, date_str, tbase_hdd=18, tbase_cdd=21):

    try:
        lat, lon = get_lan_lon_coords(location)
        alt = get_elevation_data(lat, lon)
        weather_data = fetch_weather_station(lat, lon, alt)
        date_array = convert_string_dates_to_array(date_str)
        init_date, end_date = get_time_range(date_array)
        weather_slice = extract_data_slices(weather_data, init_date, end_date)
        weather_indexes = get_weather_indexes(
            weather_slice, tbase_hdd=tbase_hdd, tbase_cdd=tbase_cdd
        )
        return (
            {
                "tmean": round(weather_indexes["mean"].mean(), 2),
                "tmin": round(weather_indexes["tmin"].mean(), 2),
                "tmax": round(weather_indexes["tmax"].mean(), 2),
                "hdd": round(weather_indexes["hdd"].sum(), 2),
                "cdd": round(weather_indexes["cdd"].sum(), 2),
                "total_prec": round(weather_indexes["prcp"].sum(), 2),
            },
            location
        )
    except Exception as err:
        print(err)
        return (
            dict.fromkeys(
                [   ], np.nan
            ),
            location
        )
