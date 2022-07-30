FROM public.ecr.aws/lambda/python:3.7

COPY app.py "${LAMBDA_TASK_ROOT}" 

COPY tf_requirements_weather.txt "${LAMBDA_TASK_ROOT}"

COPY dynamo_db.py "${LAMBDA_TASK_ROOT}"

COPY requirements_weather.txt  .

RUN pip3 install -r requirements_weather.txt --target "${LAMBDA_TASK_ROOT}"

CMD ["app.handler"]