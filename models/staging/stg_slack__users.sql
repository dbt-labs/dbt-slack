with source as (

    select * from {{ var('src_slack__users') }}

),

renamed as (

    select
        id as user_id,

        color,
        deleted,
        has_2fa,

        is_admin,
        is_app_user,
        is_bot,
        is_invited_user,
        is_owner,
        is_primary_owner,
        is_restricted,
        is_ultra_restricted,
        name,
        profile,
        real_name,
        team_id,
        two_factor_type,
        tz as timezone,
        tz_label as timezone_label,
        tz_offset as timezone_offset,
        {{ epoch_to_timestamp('updated') }} as updated_at

    from source

)

select * from renamed
