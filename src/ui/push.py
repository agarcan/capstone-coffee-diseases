import random
import boto3 
from PIL import Image
import json
from datetime import datetime

session = boto3.Session()
s3_client = session.client("s3")
s3 = boto3.resource('s3')

def generate_random_string(length = 10):
    
    lower = "abcdefghijklmnopqrstuvwxyz"
    upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    numbers = "0123456789"
    symbols = "$&=%!?"

    string = lower + upper + numbers + symbols
    return "".join(random.sample(string, length))

def upload_image(img_path, submission_id):
    bucket = "bucket-detection-trigger"
    if "jpg" in "submission_id":
        img_name = submission_id + ".jpg"
    elif "jpeg":
        img_name = submission_id + ".jpeg"
    else:
        raise ValueError('The format of the image is currently not supported, it should be (.jpg/.jpeg)')

    s3_client.upload_file(img_path, bucket, img_name)

def upload_data(submission_id, username, location, date):
    json_data = {
        "submission_id" : submission_id, 
        "username" : username,
        "location" : location,
        "date" : date 
        }
    bucket_name = "bucket-weather-trigger"
    file_name = submission_id+'.json'
    s3object = s3.Object(bucket_name, file_name)
    s3object.put(
        Body=(bytes(json.dumps(json_data).encode('UTF-8')))
    )

def input_data():
    while True:
        try:
            img_path = "test_images/" + input('Please introduce a valid path to an image: ')
            username = input('Please provide username: ')
            location = input('Provide name of the nearest municipality to the location where the iamge was taken: ')
            date = input("Provide the date when the picture was taken (yyyy-mm-dd): ")
            datetime.strptime(date, '%Y-%m-%d')

            submission_id = generate_random_string(length = 10)

            upload_image(img_path, submission_id)
            upload_data(submission_id, username, location, date)

            if input("If you wish to continue introducing images, please type 'yes'") == "yes":
                continue
            else:
                break
    
            s3.put_object(Body = iamge_bytearray, Bucket='your-s3-bucket', Key='test/test.png')
        except Exception as err:
            print("An error ocurred:")
            print(err)
            if input("Please type 'yes' if you wish to try it again") != "yes":
                break
            else:
                continue
        
input_data()
