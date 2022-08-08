import uvicorn
from starlette import status
from fastapi import Form, File, UploadFile, Request, FastAPI
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
import fetch_ddb_tables
import ui_utils

app = FastAPI()

templates = Jinja2Templates(directory="htmldirectory")
app.mount("/static", StaticFiles(directory="static"), name="static")


@app.post("/submit")
async def submission(
    username: str = Form(...),
    location: str = Form(...),
    disease_image: UploadFile = File(...),
) -> dict:

    submission_id = ui_utils.generate_random_string()

    success_check = ui_utils.upload_data(
        submission_id=submission_id, username=username, location=location
    )

    if success_check:
        ui_utils.upload_picture(
            disease_image=disease_image, submission_id=submission_id
        )

    return RedirectResponse("/home", status_code=status.HTTP_302_FOUND)


@app.get("/home", response_class=HTMLResponse)
def write_home(request: Request):
    return templates.TemplateResponse("user_data.html", {"request": request})


@app.get("/")
def read_root():
    return "Nothing to do here, please visit the /home page"


@app.get("/results/{table_name}", response_class=HTMLResponse)
async def tables_home(table_name: str, request: Request):
    data = fetch_ddb_tables.fetch_table_content(table_name)

    headings = fetch_ddb_tables.table_heads_map(table_name)
    return templates.TemplateResponse(
        "db_tables.html", {"request": request, "data": data, "headings": headings}
    )


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)
