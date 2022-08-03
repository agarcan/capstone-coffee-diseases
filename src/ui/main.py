import uvicorn
from starlette import status
from fastapi import Form, File, UploadFile, Request, FastAPI
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
import boto3
import json
import uuid

# from upload_endpoint import upload_image_to_s3
import fetch_ddb_tables

session = boto3.Session()
s3_client = session.client("s3")
s3 = boto3.resource("s3")


def generate_random_string(length: int = 10) -> str:
    return uuid.uuid4().hex[:8].upper()


def upload_picture(disease_image, submission_id: str) -> None:
    bucket = "bucket-detection-trigger"

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


app = FastAPI()

templates = Jinja2Templates(directory="htmldirectory")
app.mount("/static", StaticFiles(directory="static"), name="static")

@app.post("/submit")
async def submission(
    username: str = Form(...),
    location: str = Form(...),
    disease_image: UploadFile = File(...),
) -> dict:

    submission_id = generate_random_string()

    success_check = upload_data(
        submission_id=submission_id, username=username, location=location
    )

    if success_check:
        upload_picture(disease_image=disease_image, submission_id=submission_id)

    return RedirectResponse("/home", status_code=status.HTTP_302_FOUND)

@app.get("/home", response_class=HTMLResponse)
def write_home(request: Request):
    return templates.TemplateResponse("user_data.html", {"request": request})


table_heads_map = {
    "detection_db": ["submission_id", "label"],
    "submissions_db": ["username", "date", "submission_id"],
    "location_db": ["submission_id", "location"],
    "weather_db": [
        "submission_id",
        "tmean",
        "tmin",
        "tmax",
        "hdd",
        "cdd",
        "Hmean",
        "Pmean",
    ],
}


@app.get("/")
def read_root():
    return "Nothing to do here, please visit the /home page"


@app.get("/results/{table_name}", response_class=HTMLResponse)
async def tables_home(table_name: str, request: Request):
    data = fetch_ddb_tables.fetch_table_content(table_name)

    headings = table_heads_map[table_name]
    return templates.TemplateResponse(
        "db_tables.html", {"request": request, "data": data, "headings": headings}
    )


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)
