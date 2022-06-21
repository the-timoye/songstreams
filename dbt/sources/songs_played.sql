--  use Common Table Expressions (CTEs)

WITH temp_view_name AS (
    SELECT *
    FROM {{ source('songstreams', 'listen_events') }}
)

final as (
    SELECT *
    FROM temp_view_name
)

SELECT *
FROM final