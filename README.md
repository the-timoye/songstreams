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
- `cd lake && python extraction.py`
Spark reads data from the broker(s) every 120 seconds.
Each read is saved in a new csv.
The naming convention is sparks default - _partition_.csv,
Watch Spark perform its magic ;)

## Data Samples
The below are topics produced by the eventsim application, read via kafka, witten with Spark. With the first row of each topic before structuring

- listen events: 
        `"{\"artist\":\"Alan Silvestri\",\"song\":\"The Joes Mobilize\",\"duration\":504.05832,\"ts\":1653764521000,\"sessionId\":1862641,\"auth\":\"Logged In\",\"level\":\"paid\",\"itemInSession\":13,\"city\":\"Houston\",\"zip\":\"77082\",\"state\":\"TX\",\"userAgent\":\"\\\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.78.2 (KHTML, like Gecko) Version/7.0.6 Safari/537.78.2\\\"\",\"lon\":-95.640002,\"lat\":29.72449,\"userId\":311567,\"lastName\":\"Williams\",\"firstName\":\"Dilan\",\"gender\":\"M\",\"registration\":1495975266000}"`

- page view events
        `"{\"ts\":1653763440000,\"sessionId\":432505,\"page\":\"NextSong\",\"auth\":\"Logged In\",\"method\":\"PUT\",\"status\":200,\"level\":\"free\",\"itemInSession\":3,\"city\":\"Tampa\",\"zip\":\"33637\",\"state\":\"FL\",\"userAgent\":\"\\\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.78.2 (KHTML, like Gecko) Version/7.0.6 Safari/537.78.2\\\"\",\"lon\":-82.361113,\"lat\":28.045334,\"userId\":432506,\"lastName\":\"Perez\",\"firstName\":\"Noelle\",\"gender\":\"F\",\"registration\":1495975266000,\"artist\":\"Joanna Connor\",\"song\":\"Playing In The Dirt\",\"duration\":238.39302}"`

- auth events
        `"{\"ts\":1653763925000,\"sessionId\":1860140,\"level\":\"paid\",\"itemInSession\":3,\"city\":\"Costa Mesa\",\"zip\":\"92626\",\"state\":\"CA\",\"userAgent\":\"\\\"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36\\\"\",\"lon\":-117.911715,\"lat\":33.678399,\"userId\":505067,\"lastName\":\"Schmidt\",\"firstName\":\"Jordan\",\"gender\":\"M\",\"registration\":1575708411000,\"success\":true}"`

## Data Storage

### Data Lake (AWS S3)
The raw, uncleaned, unprocessed data is stored directly in the Data lake (S3) using Apache  Spark Streaming.
This is to ensure that:
- Data Scientists, ML Engineers get to do their deep iterations without having to slow down or kill the Warehouse.
- Since building a Warehouse will involve a lot of processing, there may be some descripancy along the line. The lake serves as an option to fall back to when the quality of the data is being tested.