import boto3
import os
client_db = boto3.client("dynamodb", region_name="eu-central-1")

os.chdir('/tmp')

def save_submissions_db(username: str, date: str, submission_id: str) -> None:

    client_db.put_item(
        TableName="submissions_db",
        Item={
            "username": {"S": username},
            "date": {"S": date},
            "submission_id": {"S": submission_id},
        },
    )


def save_location_db(submission_id: str, location: str) -> None:
    client_db.put_item(
        TableName="location_db",
        Item={"submission_id": {"S": submission_id}, "label": {"S": location}},
    )


def save_weather_db(submission_id: str, weather_data) -> None:

    client_db.put_item(
        TableName="weather_db",
        Item={
            "submission_id": {"S": submission_id},
#            "tmean": {"N": weather_data["tmean"]},
#            "tmin": {"N": weather_data["tmin"]},
#            "tmax": {"N": weather_data["tmax"]},
            "hdd": {"N": weather_data["hdd"]},
            "cdd": {"N": weather_data["cdd"]},
            "total_prec": {"N": weather_data["total_prec"]},
        },
    )
