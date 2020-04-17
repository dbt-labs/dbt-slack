{% set columns_to_select=[
    'message_id',
    'parent_message_id',
    'channel_id',
    'user_id',
    'parent_user_id',
    'sent_at',
    'parent_message_sent_at',
    'type',
    'subtype',
    'text',
    'reactions'
] %}

{% set columns_to_select_csv=columns_to_select | join (", ") %}


with posts as (

    select * from {{ ref('base_slack__messages') }}

),

replies as (

    select * from {{ ref('slack__flattened_replies') }}

),

-- subthreads appear as both posts and replies -- let's consider them a reply only
posts_excluding_thread_broadcasts as (

    select * from posts

    where subtype not in ('thread_broadcast') or subtype is null

),


unioned as (

    select {{ columns_to_select_csv }} from posts_excluding_thread_broadcasts

    union all

    select {{ columns_to_select_csv }} from replies

)

select * from unioned
