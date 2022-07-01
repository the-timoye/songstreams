## Data Samples
The below are topics produced by the eventsim application, read via kafka, witten with Spark. With the first row of each topic before structuring



- ### listen_events: 
        `"{\"artist\":\"Alan Silvestri\",\"song\":\"The Joes Mobilize\",\"duration\":504.05832,\"ts\":1653764521000,\"sessionId\":1862641,\"auth\":\"Logged In\",\"level\":\"paid\",\"itemInSession\":13,\"city\":\"Houston\",\"zip\":\"77082\",\"state\":\"TX\",\"userAgent\":\"\\\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.78.2 (KHTML, like Gecko) Version/7.0.6 Safari/537.78.2\\\"\",\"lon\":-95.640002,\"lat\":29.72449,\"userId\":311567,\"lastName\":\"Williams\",\"firstName\":\"Dilan\",\"gender\":\"M\",\"registration\":1495975266000}"`

- ### page_view_events
        `"{\"ts\":1653763440000,\"sessionId\":432505,\"page\":\"NextSong\",\"auth\":\"Logged In\",\"method\":\"PUT\",\"status\":200,\"level\":\"free\",\"itemInSession\":3,\"city\":\"Tampa\",\"zip\":\"33637\",\"state\":\"FL\",\"userAgent\":\"\\\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.78.2 (KHTML, like Gecko) Version/7.0.6 Safari/537.78.2\\\"\",\"lon\":-82.361113,\"lat\":28.045334,\"userId\":432506,\"lastName\":\"Perez\",\"firstName\":\"Noelle\",\"gender\":\"F\",\"registration\":1495975266000,\"artist\":\"Joanna Connor\",\"song\":\"Playing In The Dirt\",\"duration\":238.39302}"`

- ### auth_events
        `"{\"ts\":1653763925000,\"sessionId\":1860140,\"level\":\"paid\",\"itemInSession\":3,\"city\":\"Costa Mesa\",\"zip\":\"92626\",\"state\":\"CA\",\"userAgent\":\"\\\"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36\\\"\",\"lon\":-117.911715,\"lat\":33.678399,\"userId\":505067,\"lastName\":\"Schmidt\",\"firstName\":\"Jordan\",\"gender\":\"M\",\"registration\":1575708411000,\"success\":true}"`
