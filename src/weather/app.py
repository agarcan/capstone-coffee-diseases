import fetch_weather_data
import dynamo_db as ddb
import boto3
import json

client_s3 = boto3.client("s3", region_name="eu-central-1")


def get_bucket_content(event):

    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = event["Records"][0]["s3"]["object"]["key"]
    return key, bucket


def delete_object_in_bucket(bucket_name: str, object_name: str):
    return client_s3.delete_object(Bucket=bucket_name, Key=object_name)


def extract_submission_data_from_s3_json(object_name: str, bucket_name: str):
    print(object_name, bucket_name)

    json_file = (
        client_s3.get_object(Bucket=bucket_name, Key=object_name)["Body"]
        .read()
        .decode("utf-8")
    )
    return json.loads(json_file)


def handler(event, context):
    object_name, bucket_name = get_bucket_content(event)
    submission_data_dict = extract_submission_data_from_s3_json(
        object_name, bucket_name
    )
    delete_object_in_bucket(bucket_name, object_name)

    location = submission_data_dict["location"]
    submission_id = submission_data_dict["submission_id"]
    username = submission_data_dict["username"]

    weather_data, date_str = fetch_weather_data.weather_indexes(location)

    ddb.save_submissions_db(username, date_str, submission_id)
    ddb.save_location_db(submission_id, location)
    ddb.save_weather_db(submission_id, weather_data)
