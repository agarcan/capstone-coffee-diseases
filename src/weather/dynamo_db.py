import boto3

client_db = boto3.client("dynamodb", region_name="eu-central-1")


def save_submissions_db(username: str, date: str, submission_id: str) -> None:
    client_db.put_item(
        TableName="submissions_db",
        Item={
            "username": {"S": username},
            "submission_id": {"S": submission_id},
            "date": {"S": date},
        },
    )


def save_location_db(submission_id: str, location: str) -> None:
    client_db.put_item(
        TableName="location_db",
        Item={"submission_id": {"S": submission_id}, "location": {"S": location}},
    )


def save_weather_db(submission_id: str, weather_data: dict) -> None:
    weather_data["submission_id"] = submission_id
    client_db.put_item(
        TableName="weather_db",
        Item={key: {"S": val} for key, val in weather_data.items()},
    )
