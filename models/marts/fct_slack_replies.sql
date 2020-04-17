with messages as (

    select * from {{ ref('fct_slack_messages') }}

),

replies as (

    select
        message_id,
        parent_message_id,
        channel_id,
        channel_name,
        user_id,
        parent_user_id,
        text,
        reactions,
        number_of_reactions,
        sent_at

    from messages

    where is_reply

)

select * from replies
