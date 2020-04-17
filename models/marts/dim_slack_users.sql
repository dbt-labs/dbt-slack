{{
    config(
        materialized='table'
    )
}}

with users as (

    select * from {{ ref('stg_slack__users') }}

),

channel_joins as (

    select * from {{ ref('fct_slack_channel_joins') }}

),

messages as (

    select * from {{ ref('fct_slack_messages') }}

),

user_channel_joins as (

    select
        user_id,
        min(joined_at) as first_joined_at

    from channel_joins

    group by 1

),


user_messages as (

    select
        user_id,
        min(sent_at) as first_message_at,
        count(*) as number_of_messages,
        count(case when is_post then message_id end) as number_of_posts,
        count(case when is_reply then message_id end) as number_of_replies

    from messages

    group by 1

),

final as (

    select
        users.user_id,
        users.name,
        users.timezone,
        user_channel_joins.first_joined_at as joined_at,

        row_number() over (
            order by joined_at
        ) as nth_user,

        user_messages.first_message_at,
        user_messages.first_message_at is not null as has_messaged,

        coalesce(user_messages.number_of_messages, 0) as number_of_messages,
        coalesce(user_messages.number_of_posts, 0) as number_of_posts,
        coalesce(user_messages.number_of_replies, 0) as number_of_replies,

        1.0 * user_messages.number_of_replies / nullif(user_messages.number_of_messages, 0)
            as reply_to_messages_ratio

    from users

    left join user_channel_joins
        on users.user_id = user_channel_joins.user_id

    left join user_messages
        on users.user_id = user_messages.user_id

)

select * from final
