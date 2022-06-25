WITH listen_event_levels AS (
    SELECT level
    FROM {{source('dev', 'listen_events')}}
 ),
 page_view_event_levels AS (
    SELECT level
    FROM {{source('dev', 'page_view_events')}}
 ),
 auth_event_levels AS (
    SELECT level
    FROM {{source('dev', 'auth_events')}}
 ),
 all_event_levels AS (
    SELECT level
    FROM  auth_event_levels
    UNION
    SELECT level
    FROM  page_view_event_levels
    UNION
    SELECT level
    FROM  listen_event_levels
 )

 SELECT {{ dbt_utils.surrogate_key(
    'level'
  ) }}, level
 FROM all_event_levels