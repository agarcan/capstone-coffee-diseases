import boto3
client_db = boto3.client("dynamodb", region_name="eu-central-1")

def save_submission_db(
    username, 
    date, 
    submission_id
    ):

    client_db.put_item(
        TableName="detection_db",
        Item={
            "submission_id": {"S": username}, 
            "date": {"S": date},
            "submission_id": {"S": submission_id}
            }
    )

def save_location_db(submission_id, location):
    client_db.put_item(
        TableName="location_db",
        Item={
            "submission_id": {"S": submission_id}, 
            "label": {"S": location}
            },
    )

def save_weather_db(submission_id, weather_data):

    client_db.put_item(
    TableName="weather_db",
    Item={
        "submission_id": {"S": submission_id}, 
        "tmean": {"N": weather_data["tmean"]},
        "tmin": {"N": weather_data["tmin"]},
        "tmax": {"N": weather_data["tmax"]},
        "hdd": {"N": weather_data["hdd"]},
        "cdd": {"N": weather_data["cdd"]},
        "total_prec": {"N": weather_data["total_prec"]}
        }
)