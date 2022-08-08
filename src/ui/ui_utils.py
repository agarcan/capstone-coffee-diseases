import boto3
import uuid
import json

session = boto3.Session()
s3_client = session.client("s3")
s3 = boto3.resource("s3")
bucket = "bucket-detection-trigger"


def generate_random_string(length: int = 10) -> str:
    return uuid.uuid4().hex[:8].upper()


def upload_picture(disease_image, submission_id: str) -> None:
    img_name = submission_id + ".jpg"
    s3_client.upload_fileobj(disease_image.file, bucket, img_name)


def upload_data(submission_id: str, username: str, location: str) -> None:
    json_data = {
        "submission_id": submission_id,
        "username": username,
        "location": location,
    }
    try:
        bucket_name = "bucket-weather-trigger"
        file_name = submission_id + ".json"
        s3object = s3.Object(bucket_name, file_name)
        s3object.put(Body=(bytes(json.dumps(json_data).encode("UTF-8"))))
        return True
    except Exception as err:
        print(err)
        return False
