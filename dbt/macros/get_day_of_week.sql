{% macro get_day_of_week(numeric_day)  %}

    {% set monday=2 %}
    {% set tuesday=3 %}
    {% set wednessday=4 %}
    {% set thursday=5 %}
    {% set friday=6 %}
    {% set saturday=7 %}
    {% set sunday=1 %}

    {% if numeric_day ==  2 %}
        {{ 'Monday' }}
    {% elif numeric_day ==  3 %}
        {{ 'Tuesday' }}
    {% elif numeric_day ==  4 %}
        {{ 'Wednessday' }}
    {% elif numeric_day ==  5 %}
        {{ 'Thursday' }}
    {% elif numeric_day ==  6 %}
        {{ 'Friday' }}
    {% elif numeric_day ==  7 %}
        {{ 'Saturday' }}
    {% elif numeric_day ==  1 %}
        {{ 'Sunday' }}
    {% else %}    
        {{ 'N/A' }}
    {% endif %}
{% endmacro %}