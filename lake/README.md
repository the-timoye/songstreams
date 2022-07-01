# Data Lake (AWS S3)

### Description
While `Spark` consumes the data streamed from `Kafka`, the following approaches are followed to ensure clean processed data: <br>
- appropraite datatype specification for each column.<br>
- all null values are replaced with `N/A` for string datatypes and `-404` for numerial and other datatypes to ensure uniqness in its adentification and prevent loss of needed data.<br>
- columns are renamed using explicit names and snake_case naming method for easy comprehension.<br>
For example, `ts`, `lon` and `lat` are renamed to `timestamp`, `longitude`, and `latitude`.<br>
- gran
- additional columns such as `second`, `is_weeked` have been added for simplicity and understanding of the data. <br>
- all files are cleaned and stored in two specified AWS S3 storage buckets: _raw_ and _clean_ for rechecking and testing situations. <br>
- all files are stored in `csv` format


### Schema

<style type="text/css">
.tg  {border-collapse:collapse;border-color:#bbb;border-spacing:0;}
.tg td{background-color:#E0FFEB;border-color:#bbb;border-style:solid;border-width:1px;color:#594F4F;
  font-family:Arial, sans-serif;font-size:14px;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{background-color:#9DE0AD;border-color:#bbb;border-style:solid;border-width:1px;color:#493F3F;
  font-family:Arial, sans-serif;font-size:14px;font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-9l13{border-color:#bbbbbb;font-weight:bold;text-align:center;vertical-align:top}
.tg .tg-baqh{text-align:center;vertical-align:top}
.tg .tg-amwm{font-weight:bold;text-align:center;vertical-align:top}
.tg .tg-0lax{text-align:left;vertical-align:top}
.tg .tg-b1fc{border-color:#bbbbbb;text-align:center;vertical-align:top}
</style>
<table class="tg">
<thead>
  <tr>
    <th class="tg-amwm" colspan="3">page_view_events</th>
    <th class="tg-0lax"></th>
    <th class="tg-amwm" colspan="3">listen_events</th>
    <th class="tg-baqh"></th>
    <th class="tg-amwm" colspan="3">auth_events</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-9l13">column_name</td>
    <td class="tg-9l13">renamed_to</td>
    <td class="tg-9l13">datatype</td>
    <td class="tg-0lax"></td>
    <td class="tg-amwm">column_name</td>
    <td class="tg-amwm">remaned_to</td>
    <td class="tg-amwm">datatype</td>
    <td class="tg-amwm"></td>
    <td class="tg-amwm">column_name</td>
    <td class="tg-amwm">renamed_to</td>
    <td class="tg-amwm">datatype</td>
  </tr>
  <tr>
    <td class="tg-b1fc">ts</td>
    <td class="tg-b1fc">timestamp</td>
    <td class="tg-b1fc">bigint</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">artist</td>
    <td class="tg-baqh">artist</td>
    <td class="tg-baqh">sting</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">ts</td>
    <td class="tg-baqh">timestamp</td>
    <td class="tg-baqh">bigint</td>
  </tr>
  <tr>
    <td class="tg-b1fc">sessionId</td>
    <td class="tg-b1fc">session_id</td>
    <td class="tg-b1fc">bigint</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">song</td>
    <td class="tg-baqh">session_id</td>
    <td class="tg-baqh">bigint</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">sessionId</td>
    <td class="tg-baqh">session_id</td>
    <td class="tg-baqh">bigint</td>
  </tr>
  <tr>
    <td class="tg-b1fc">page</td>
    <td class="tg-b1fc">page</td>
    <td class="tg-b1fc">string</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">ts</td>
    <td class="tg-baqh">timestamp</td>
    <td class="tg-baqh">bigint</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">level</td>
    <td class="tg-baqh">level</td>
    <td class="tg-baqh">string</td>
  </tr>
  <tr>
    <td class="tg-baqh">auth</td>
    <td class="tg-baqh">auth</td>
    <td class="tg-baqh">string</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">sessionId</td>
    <td class="tg-baqh">session_id</td>
    <td class="tg-baqh">bigint</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">itemInSession</td>
    <td class="tg-baqh">item_in_session</td>
    <td class="tg-baqh">integer</td>
  </tr>
  <tr>
    <td class="tg-baqh">method</td>
    <td class="tg-baqh">method</td>
    <td class="tg-baqh">string</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">auth</td>
    <td class="tg-baqh">auth</td>
    <td class="tg-baqh">string</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">city</td>
    <td class="tg-baqh">city</td>
    <td class="tg-baqh">string</td>
  </tr>
  <tr>
    <td class="tg-baqh">status</td>
    <td class="tg-baqh">status</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">level</td>
    <td class="tg-baqh">level</td>
    <td class="tg-baqh">string</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">zip</td>
    <td class="tg-baqh">zip</td>
    <td class="tg-baqh">integer</td>
  </tr>
  <tr>
    <td class="tg-baqh">level</td>
    <td class="tg-baqh">level</td>
    <td class="tg-baqh">string</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">itemInSession</td>
    <td class="tg-baqh">item_in_session</td>
    <td class="tg-baqh">string</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">state</td>
    <td class="tg-baqh">state</td>
    <td class="tg-baqh">string</td>
  </tr>
  <tr>
    <td class="tg-baqh">itemInSession</td>
    <td class="tg-baqh">item_in_session</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">city</td>
    <td class="tg-baqh">city</td>
    <td class="tg-baqh">string</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">userAgent</td>
    <td class="tg-baqh">user_agent</td>
    <td class="tg-baqh">string</td>
  </tr>
  <tr>
    <td class="tg-baqh">city</td>
    <td class="tg-baqh">city</td>
    <td class="tg-baqh">string</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">zip</td>
    <td class="tg-baqh">zip</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">lon</td>
    <td class="tg-baqh">longitude</td>
    <td class="tg-baqh">double</td>
  </tr>
  <tr>
    <td class="tg-baqh">zip</td>
    <td class="tg-baqh">zip</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">state</td>
    <td class="tg-baqh">state</td>
    <td class="tg-baqh">string</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">lat</td>
    <td class="tg-baqh">latitude</td>
    <td class="tg-baqh">double</td>
  </tr>
  <tr>
    <td class="tg-baqh">state</td>
    <td class="tg-baqh">state</td>
    <td class="tg-baqh">string</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">userAgent</td>
    <td class="tg-baqh">user_agent</td>
    <td class="tg-baqh">string</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">userId</td>
    <td class="tg-baqh">user_id</td>
    <td class="tg-baqh">integer</td>
  </tr>
  <tr>
    <td class="tg-baqh">userAgent</td>
    <td class="tg-baqh">user_agent</td>
    <td class="tg-baqh">string</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">lon</td>
    <td class="tg-baqh">longitude</td>
    <td class="tg-baqh">bigint</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">lastName</td>
    <td class="tg-baqh">last_name</td>
    <td class="tg-baqh">string</td>
  </tr>
  <tr>
    <td class="tg-baqh">lon</td>
    <td class="tg-baqh">longitude</td>
    <td class="tg-baqh">double</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">lat</td>
    <td class="tg-baqh">latitude</td>
    <td class="tg-baqh">bigint</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">firstName</td>
    <td class="tg-baqh">first_name</td>
    <td class="tg-baqh">string</td>
  </tr>
  <tr>
    <td class="tg-baqh">lat</td>
    <td class="tg-baqh">latitude</td>
    <td class="tg-baqh">double</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">userId</td>
    <td class="tg-baqh">user_id</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">gender</td>
    <td class="tg-baqh">gender</td>
    <td class="tg-baqh">string</td>
  </tr>
  <tr>
    <td class="tg-baqh">userId</td>
    <td class="tg-baqh">user_id</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">lastName</td>
    <td class="tg-baqh">last_name</td>
    <td class="tg-baqh">string</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">registration</td>
    <td class="tg-baqh">registration</td>
    <td class="tg-baqh">bigint</td>
  </tr>
  <tr>
    <td class="tg-baqh">lastName</td>
    <td class="tg-baqh">last_name</td>
    <td class="tg-baqh">string</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">firstName</td>
    <td class="tg-baqh">first_name</td>
    <td class="tg-baqh">string</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">success</td>
    <td class="tg-baqh">success</td>
    <td class="tg-baqh">boolean</td>
  </tr>
  <tr>
    <td class="tg-baqh">firstName</td>
    <td class="tg-baqh">first_name</td>
    <td class="tg-baqh">string</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">gender</td>
    <td class="tg-baqh">gender</td>
    <td class="tg-baqh">string</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
  </tr>
  <tr>
    <td class="tg-baqh">gender</td>
    <td class="tg-baqh">gender</td>
    <td class="tg-baqh">string</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">registration</td>
    <td class="tg-baqh">registration</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
  </tr>
  <tr>
    <td class="tg-baqh">registration</td>
    <td class="tg-baqh">registration</td>
    <td class="tg-baqh">bigint</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
  </tr>
  <tr>
    <td class="tg-baqh">artist</td>
    <td class="tg-baqh">artist</td>
    <td class="tg-baqh">string</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
  </tr>
  <tr>
    <td class="tg-baqh">song</td>
    <td class="tg-baqh">song</td>
    <td class="tg-baqh">string</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
  </tr>
  <tr>
    <td class="tg-baqh">duration</td>
    <td class="tg-baqh">duration</td>
    <td class="tg-baqh">double</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">-</td>
  </tr>
  <tr>
    <td class="tg-amwm" colspan="11">new columns</td>
  </tr>
  <tr>
    <td class="tg-0lax">-</td>
    <td class="tg-baqh">year</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">year</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">year</td>
    <td class="tg-baqh">integer</td>
  </tr>
  <tr>
    <td class="tg-0lax">-</td>
    <td class="tg-baqh">month</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">month</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">month</td>
    <td class="tg-baqh">integer</td>
  </tr>
  <tr>
    <td class="tg-0lax">-</td>
    <td class="tg-baqh">abs_date</td>
    <td class="tg-baqh">timestamp</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">abs_date</td>
    <td class="tg-baqh">timestamp</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">abs_date</td>
    <td class="tg-baqh">timestamp</td>
  </tr>
  <tr>
    <td class="tg-0lax">-</td>
    <td class="tg-baqh">hour</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">hour</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">hour</td>
    <td class="tg-baqh">integer</td>
  </tr>
  <tr>
    <td class="tg-0lax">-</td>
    <td class="tg-baqh">day</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">day</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">day</td>
    <td class="tg-baqh">integer</td>
  </tr>
  <tr>
    <td class="tg-0lax">-</td>
    <td class="tg-baqh">day_of_week</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">day_of_week</td>
    <td class="tg-baqh">integer</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">day_of_week</td>
    <td class="tg-baqh">integer</td>
  </tr>
  <tr>
    <td class="tg-0lax">-</td>
    <td class="tg-baqh">is_weekend</td>
    <td class="tg-baqh">boolean</td>
    <td class="tg-0lax"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">is_weekend</td>
    <td class="tg-baqh">boolean</td>
    <td class="tg-baqh"></td>
    <td class="tg-baqh">-</td>
    <td class="tg-baqh">is_weekend</td>
    <td class="tg-baqh">boolean</td>
  </tr>
</tbody>
</table>