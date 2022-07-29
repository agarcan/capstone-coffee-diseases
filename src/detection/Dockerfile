FROM public.ecr.aws/lambda/python:3.7

COPY app.py "${LAMBDA_TASK_ROOT}" 

COPY CoffeeLeaves_lite_model.tflite "${LAMBDA_TASK_ROOT}"

COPY coffee_leaves_labels.json "${LAMBDA_TASK_ROOT}"

COPY tf_requirements.txt  .

RUN pip3 install -r tf_requirements.txt --target "${LAMBDA_TASK_ROOT}"

CMD ["app.handler"]

