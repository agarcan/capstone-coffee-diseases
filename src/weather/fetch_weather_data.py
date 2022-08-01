from geopy.geocoders import Nominatim
import pandas as pd
from meteostat import Point, Daily
import numpy as np

from datetime import datetime
from dateutil.relativedelta import relativedelta
import requests

geolocator = Nominatim(user_agent="capstone-project-aws")


def _get_time_range(date_str: str) -> tuple[datetime.date, datetime.date]:
    end_time = datetime.strptime(date_str, "%Y-%m-%d")
    init_time = end_time - relativedelta(months=1)
    return init_time, end_time


def _set_datetime(year: str, month: str, day: str) -> datetime:
    return datetime(year, month, day)


def _fetch_weather_station(lon: float, lat: float, alt: float):
    return Point(lon, lat, alt)


def _extract_data_slices(
    weather_data: pd.DataFrame, start: datetime, end: datetime
) -> pd.DataFrame:
    return Daily(weather_data, start, end).fetch()


def _get_elevation_data(lat: float, lon: float) -> float:
    url = "https://api.opentopodata.org/v1/srtm90m"
    query = {
        "locations": f"{lat}, {lon}",
        "interpolation": "cubic",
    }
    response = requests.post(url, json=query)
    return eval(response.content)["results"][0]["elevation"]


def _get_lan_lon_coords(location: str) -> tuple[float, float]:
    location = geolocator.geocode(location)
    return location.latitude, location.longitude


def get_weather_for_address(location: str):

    lat, lon = _get_lan_lon_coords(location)
    alt = _get_elevation_data(lat, lon)

    return _fetch_weather_station(lat, lon, alt)


def get_weather_indexes(
    weather_data: pd.DataFrame, tbase_hdd: float, tbase_cdd: float
) -> pd.DataFrame:
    tmp_data = weather_data.copy()
    tmp_data["mean"] = (tmp_data["tmin"] + tmp_data["tmax"]) * 0.5
    tmp_data["hdd"] = tmp_data["mean"].apply(
        lambda x: tbase_hdd - x if x < tbase_hdd else 0
    )
    tmp_data["cdd"] = tmp_data["mean"].apply(
        lambda x: x - tbase_cdd if x > tbase_hdd else 0
    )
    return tmp_data.loc[:, ["mean", "tmin", "tmax", "hdd", "cdd", "prcp"]]


def weather_indexes(
    location: str, date_str: str, tbase_hdd: float = 18, tbase_cdd: float = 21
) -> dict[
    dict[str:float],
    dict[str:float],
    dict[str:float],
    dict[str:float],
    dict[str:float],
    dict[str:float],
]:

    try:
        lat, lon = _get_lan_lon_coords(location)
        alt = _get_elevation_data(lat, lon)
        weather_data = _fetch_weather_station(lat, lon, alt)
        init_date, end_date = _get_time_range(date_str)
        weather_slice = _extract_data_slices(weather_data, init_date, end_date)
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
        )
    except Exception as err:
        print(err)
        return dict.fromkeys([], np.nan)
