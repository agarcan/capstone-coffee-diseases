import boto3

db = boto3.resource("dynamodb")


def table_heads_map(table_name):
    table_cols = {
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

    return table_cols[table_name]


def fetch_row_content(row, table_heads):
    return tuple(row[key] for key in table_heads)


def fetch_table_content(table_name):

    target_table = db.Table(table_name)
    table_heads = table_heads_map(table_name)
    table_soup = target_table.scan()
    table_content = [fetch_row_content(row, table_heads) for row in table_soup["Items"]]

    return table_content
