import pymysql
import os

db_endpoint = os.environ["DB_ENDPOINT"]
user_name = os.environ["DB_USERNAME"]
password = os.environ["DB_PASSWD"]
db_name = os.environ["DB_NAME"]

connection = pymysql.connect(host=db_endpoint, user=user_name, passwd=password, db=db_name)


def save_submissions_db(username: str, date: str, submission_id: str) -> None:
    init_sql = """CREATE TABLE [IF NOT EXISTS] submissions_db(
        submission_id VARCHAR(255) AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255) NOT NULL,
        date VARCHAR(255)
        ); 
    """

    sql = """INSERT INTO submissions_db (submission_id, username, date) VALUES (%s, %s, %s);"""

    with connection as con:
        with con.cursor() as cursor:
            cursor.execute(init_sql)
            cursor.execute(sql(submission_id, user_name, date))
            

def save_location_db(submission_id: str, location: str) -> None:
    init_sql = """CREATE TABLE [IF NOT EXISTS] location_db(
        submission_id VARCHAR(255),
        location VARCHAR(255),
        FOREIGN KEY (submission_id) REFERENCES submissions_db(submission_id)
        ); """

    sql = """INSERT INTO location_db(submission_id, location) VALUES (%s, %s);"""

    with connection as con:
        with con.cursor() as cursor:
            cursor.execute(init_sql)
            cursor.execute(sql(submission_id, location))


def save_weather_db(submission_id: str, weather_data: dict) -> None:
    init_sql = """CREATE TABLE [IF NOT EXISTS] weather_db(
            submission_id VARCHAR(255),
            tmean FLOAT,
            tmin FLOAT,
            tmax FLOAT,
            Hmean FLOAT,
            Pmean FLOAT,
            cdd FLOAT,
            hdd FLOAT,
            FOREIGN KEY (submission_id) REFERENCES submissions_db(submission_id)
            ); """

    sql = """INSERT INTO weather_db(
            submission_id, 
            tmean,
            tmin,
            tmax,
            Hmean,
            Pmean,
            cdd,
            hdd
            ) VALUES (%s, %s,%s, %s,%s, %s,%s, %s);"""

    with connection as con:
        with con.cursor() as cursor:
            cursor.execute(init_sql)
            cursor.execute(
                sql(
                    submission_id,
                    round(weather_data["tmean"], 2),
                    round(weather_data["tmin"], 2),
                    round(weather_data["tmax"], 2),
                    round(weather_data["Hmean"], 2),
                    round(weather_data["Pmean"], 2),
                    round(weather_data["cdd"], 2),
                    round(weather_data["hdd"], 2),
                )
            )
