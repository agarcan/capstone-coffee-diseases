import random
import boto3
import json
import uuid
from datetime import datetime

session = boto3.Session()
s3_client = session.client("s3")
s3 = boto3.resource("s3")


def generate_random_string(length: int = 10) -> str:

    return uuid.uuid4().hex[:8].upper()


def upload_image(img_path: str, submission_id: str) -> None:
    bucket = "bucket-detection-trigger"
    if "jpg" in "submission_id":
        img_name = submission_id + ".jpg"
    elif "jpeg":
        img_name = submission_id + ".jpeg"
    else:
        raise ValueError(
            "The format of the image is currently not supported, it should be (.jpg/.jpeg)"
        )

    s3_client.upload_file(img_path, bucket, img_name)


def upload_data(submission_id: str, username: str, location: str) -> None:
    json_data = {
        "submission_id": submission_id,
        "username": username,
        "location": location,
    }
    bucket_name = "bucket-weather-trigger"
    file_name = submission_id + ".json"
    s3object = s3.Object(bucket_name, file_name)
    s3object.put(Body=(bytes(json.dumps(json_data).encode("UTF-8"))))


def input_data() -> None:
    while True:
        try:
            img_path = "test_images/" + input(
                "Please introduce a valid path to an image: "
            )
            username = input("Please provide username: ")
            location = input(
                "Provide name of the nearest municipality to the location where the iamge was taken: "
            )

            submission_id = generate_random_string(length=10)

            upload_image(img_path, submission_id)
            upload_data(submission_id, username, location)

            if (
                input("If you wish to continue introducing images, please type 'yes'  ")
                == "yes"
            ):
                continue
            else:
                break

        except Exception as err:
            print("An error ocurred:")
            print(err)
            if input("Please type 'yes' if you wish to try it again") != "yes":
                break
            else:
                continue


input_data()
