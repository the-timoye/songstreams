# SONGSTREAMS
Data Engineering on a simulated song streaming application with Kafka, PySpark, dbt, S3, Redshift.

### Assumption: 
Streamify is a music streaming company that joys in the satisfaction of their users. The intelligence of the application is derived from the team of Data Techies who track, monitor, and filter out playlists uniquely for each user, making it less probable for a user to skip through a track because this app knows them so well.

Some common question asked by the Business Intelligence team are:
- What song/genre does user A play the most? <br>
- What artists are listened to the most by each user? <br>
- At what time are these particular artists listened to? <br>
- Most played songs per location <br>

## Tools
#### Infrastructure as Code (Provisioning)
- Terraform
#### Streaming 
- Apache Kafka
- Apache Spark
#### Workflow Management
- Apache Airflow
#### Data Lake
- AWS S3
#### Data Warehouse
- Amazon Redshift


## Streamed Data Damples
- [listen events](/kafka/README.md###listen_events)
- [page view events](kafka/README.md###page_view_events)
- [auth events](/kafka/README.md###auth_events)


## Data Representation
- [S3 schema](/lake/README.md#schema)


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
- `cd lake && python extraction.py`
Spark reads data from the broker(s) every 120 seconds.
Each read is saved in a new csv.
The naming convention is sparks default - _partition_.csv,
Watch Spark perform its magic ;)