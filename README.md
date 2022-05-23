# SONG STREAMS


## Tools
### Infrastructure as Code (Provisioning)
- Terraform
### Streaming 
- Apache Kafka
- Apache Spark
### Workflow Management
- Apache Airflow
### Data Lake
- AWS S3
### Data Warehouse
- Amazon Redshift


## How to run this project

### Get docker installed and running
- Visit the docker page to install docker on your Mac, Windows, or Linux OSes. Test run this installation by creating a dummy hello-world image. If this works, you're good to go.
- Don't forget to log in on your terminal with `docker login` or `sudo docker login`. Enter your username and password.

### Get zookeeper, kafka, and its brokers up and running
- run the following code to power kafka `cd kafka && docker compose build && docker compose up`
- if all builds well, you'll be able to view the confluence UI in your browser. (localhost:9021).

### Start streaming Eventsim data
- `cd scripts && bash eventsim_startup.sh`
- (optional) run `docker --follow million_events` to see logs
- it may take a while to see these topics reflect in your UI. But once it does, you'll have about four topics all together.

### Listen Via Spark
- `cd spark && python spark.py`
Spark reads data from the broker(s) every 120 seconds.
Each read is saved in a new csv.
The naming convention is sparks default - _partition_.csv,
Watch Spark perform its magic ;)