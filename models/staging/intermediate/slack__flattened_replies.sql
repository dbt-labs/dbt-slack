with messages as (

    select * from {{ ref('base_slack__messages') }}

),

flattened as (

    select
        message_id as parent_message_id,
        channel_id,
        value:user::text as user_id,
        user_id as parent_user_id,
        value:text::text as text,
        value:reactions as reactions,
        value:type::text as type,
        value:ts::decimal(18,6) as ts,
        value:thread_ts::decimal(18,6) as thread_ts

    from messages, lateral flatten (input=>threaded_replies)

    -- the first reply is the actual message, so exclude it
    where index != 0

),

renamed as (

    select
        -- ids
        {{ dbt_utils.surrogate_key(
            'ts',
            'channel_id'
        ) }} as message_id,

        parent_message_id,
        channel_id,
        user_id,
        parent_user_id,

        {{ epoch_to_timestamp('ts') }} as sent_at,
        {{ epoch_to_timestamp('thread_ts') }} as parent_message_sent_at,
        type,
        null::string as subtype,
        text,
        reactions,
        'current_flattened' as _dbt_source

    from flattened

),

-- subtype=="thread_broadcast" isn't recorded in the replies array, so grab this
-- from the original messages if it exists
final as (

    select
        renamed.message_id,
        renamed.parent_message_id,
        renamed.channel_id,
        renamed.user_id,
        renamed.parent_user_id,

        renamed.sent_at,
        renamed.parent_message_sent_at,
        renamed.type,
        messages.subtype,
        renamed.text,
        renamed.reactions,
        renamed._dbt_source

    from renamed

    left join messages
        on renamed.message_id = messages.message_id

)

select * from final
