{% docs src_slack__messages %}
This table regularly syncs the last 30 days of messages in Slack. Any records
that have updated will be overwritten.

There are a couple of important differences in the structure of this table
compared to the `raw.slack.messages` table, in particular:
* In this data source, threads are represented as an array in the `replies`
column. Importantly, the first item in the array is the original message.
* The columns vary across the two tables in small ways (e.g. channel_name vs.
channel_id).
{% enddocs %}

{% docs src_slack_historical__messages %}
This table contains all historical messages up until 2019-09-24 21:06:14.

This table is at the grain on one record per "message", where messages include
bot messages, channel joins, etc. (see "subtype" below).

There are a couple of important differences in the structure of this table
compared to the `raw.slack.messages` table, in particular:
* In this data source, threads are represented as a separate record
* The columns vary across the two tables in small ways (e.g. channel_name vs.
channel_id).
{% enddocs %}
