import fetch_weather_data
import dynamo_db as ddb
import numpy as np
import boto3
import json

client_s3 = boto3.client("s3", region_name="eu-central-1")

def get_bucket_content(event):
     
    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = event["Records"][0]["s3"]["object"]["key"]
    return key, bucket

def delete_object_in_bucket(bucket_name, object_name):
    return client_s3.delete_object(Bucket=bucket_name, Key=object_name)

def extract_submission_data_from_s3_json(object_name, bucket_name):

    json_file = (
        client_s3.get_object(Bucket=bucket_name, Key=object_name)["Body"]
        .read()
        .decode("utf-8")
    )
    return json.loads(json_file)


def handler(event, context):
    object_name, bucket_name = get_bucket_content(event)
    submittion_data_dict = extract_submission_data_from_s3_json(
        object_name, 
        bucket_name
        )
    delete_object_in_bucket( bucket_name, object_name)

    location = submittion_data_dict["location"]
    date_str = submittion_data_dict["date"]
    submission_id = submittion_data_dict["submission_id"]
    username = submittion_data_dict["username"]

    weather_data = fetch_weather_data.weather_indexes(location, date_str)
    
    ddb.save_submission_db(username, date_str, submission_id)
    ddb.save_location_db(submission_id, location)
    ddb.save_weather_db(submission_id, weather_data)

    
