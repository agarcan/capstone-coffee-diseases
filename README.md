![](/support/coffee_leaves.png?raw=true)

# capstone-coffee-diseases

AWS lambda serverless based backend to detect coffee plant diseases, using plant leave pictures. By providing the location where the picture was taken, the diagnose is 
completed with weather indicators. The detection classes include:

- “leaf_rust”
- “miner”
- “cercospora”
- “phoma”
- “healthy” 

The detection model consists in a Keras implementation of Efficientnet3, trained on data from the Arabica coffee leaf datasets known as JMuBEN and JMuBEN2. Once trained, the model was converted to TensorFlowLite and served in a docker container on a AWS-Lambda function. The detection results are estimated along with the weather conditions (in additional lambda function) at present time (assuming the picture is taken and uploaded on the same day). After detection, the rescaled images are automatically stored in an AWS S3 bucket. The detection, the weather data and user information are stored in an AWS  Dynamo_DB database.

Basically, deployment of the model, AWS infrastructure and execution requires of valid 1)AWS, 2) OpenWeather accounts, as well as preinstallation of 3) Docker, 4) Terraform and 5) FastAPI.

Once passwords are stored as GitHub secrets, the full deployment can be achieved by executing the pipeline of Git actions specified in the file `/.github/workflows/deploy.yaml`.

A basic interface to load data and visualise results is provided in folder `src/ui/main.py`.

A further specification of dependencies required is provided in the `requirement.txt` files stored in `/src/detection` and `/src/weather/`.

Note of caution: the model was duly trained, validated and tested on disjoint datasets. However, leak of information across the train-validation splits cannot be ruled out, since the image names in the dataset do not allow to discriminate whether the two pictures may correspond to a same plant or leave.

A relational database implementation can be found in branch wip_mysql, which is at present incomplete as it lacks application of aws RDS_proxy (required to armonize the use of lambda functions with RDS database).