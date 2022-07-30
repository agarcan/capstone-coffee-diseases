import tensorflow as tf  # tensorflow              2.6.0
import numpy as np
import urllib
from PIL import Image
import boto3
import json
import io

client_s3 = boto3.client("s3", region_name="eu-central-1")

def load_labels_dict(filename="coffee_leaves_labels.json"):

    with open(filename, "r") as f:
        return json.load(f)


def load_tflite_model(model_name="CoffeeLeaves_lite_model.tflite"):

    interpreter = tf.lite.Interpreter(model_path=model_name)
    interpreter.allocate_tensors()
    return interpreter


def preprocess_input(model_interpreter, img_array):

    input_details = model_interpreter.get_input_details()
    input_index = input_details[0]["index"]

    output_details = model_interpreter.get_output_details()
    output_index = output_details[0]["index"]

    model_interpreter.set_tensor(input_index, img_array)
    model_interpreter.invoke()

    return model_interpreter, output_index


def predict(model_interpreter, img_array):

    (processed_model, processed_img) = preprocess_input(model_interpreter, img_array)
    return processed_model.get_tensor(processed_img)


def get_bucket_image_content(event):

    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = urllib.parse.unquote_plus(
        event["Records"][0]["s3"]["object"]["key"], encoding="utf-8"
    )

    return key, bucket

def delete_image_in_bucket(bucket_name, image_name):
    return client_s3.delete_object(Bucket=bucket_name, Key=image_name)

def extract_image_from_s3_and_resize(image_name, bucket_name):
    try:
        response = client_s3.get_object(Bucket=bucket_name, Key=image_name)
    except Exception as e:
        print(e)
        print(
            "Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.".format(
                image_name, bucket_name
            )
        )
        raise e

    image_bytes = io.BytesIO(response["Body"].read())
    with Image.open(image_bytes) as img:
        return np.expand_dims((np.array(img.resize((299, 299)), np.float32)), axis=0)


def save_image_thumbnail(img_array, image_name, predicted_class):
    prefix = image_name.split(".")[0]

    new_name = f"{prefix}_{predicted_class}.jpg"
    with Image.fromarray(np.squeeze(img_array, axis=0).astype("uint8"), "RGB") as img:
        in_mem_file = io.BytesIO()
        img.save(in_mem_file, format="JPEG")
        in_mem_file.seek(0)

        client_s3.upload_fileobj(
            in_mem_file,
            "s3-thumbnail-pool",
            new_name,
        )


def save_submission_db(image_name, predicted_class):
    client_db.put_item(
        TableName="detection_db",
        Item={"submission_id": {"S": image_name}, "label": {"S": predicted_class}},
    )


def handler(event, context):

    model_name = "CoffeeLeaves_lite_model.tflite"
    labels_file = "coffee_leaves_labels.json"
    class_mapping = load_labels_dict(filename=labels_file)
    image_name, bucket_name = get_bucket_image_content(event)
    img_array = extract_image_from_s3_and_resize(image_name, bucket_name)
    delete_image_in_bucket(bucket_name, image_name)
    model = load_tflite_model(model_name=model_name)
    pred = predict(model, img_array)
    predicted_class = class_mapping[str(np.argmax(pred))]
    save_image_thumbnail(img_array, image_name, predicted_class)
    save_submission_db(image_name, predicted_class)
