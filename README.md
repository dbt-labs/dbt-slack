# ***Archival Notice***
This repository has been archived.

As a result all of its historical issues and PRs have been closed.

Please *do not clone* this repo without understanding the risk in doing so:
- It may have unaddressed security vulnerabilities
- It may have unaddressed bugs

<details>
   <summary>Click for historical readme</summary>

# dbt-slack
A package for sourcing and transforming data from the slack tap

## Database compatibility
✅ Snowflake

## Instructions
1. Install this package by adding it to your `packages.yml` file and running `dbt deps` ([docs](https://docs.getdbt.com/docs/building-a-dbt-project/package-management/))
2. Prep your source data:
    - If you only have one schema:
      - If your source data lives in the `raw.slack` schema, you're good to go!
      - If your source data lives in a different schema, copy the `src_slack.yml` [file](models/staging/src_slack.yml) into your own project and update as required. The `source` in your own project will override the `source` in this project.
    - If your data lives in multiple schemas, or needs some other transformation to get it into the right structure
      - Do this data preparation in your own project
      - Optionally override which Relations (i.e. `ref`s or `source`s) get passed through this package by adding the following to your `dbt_project.yml` file:
      ```yml
      models:
        slack:
          vars:
            src_slack__messages: &quot;{{ ref('unioned_slack_messages') }}&quot; # update this with the correct `ref` or `source`
            src_slack__users: &quot;{{ source('slack', 'users') }}&quot;
            src_slack__channels: &quot;{{ source('slack', 'channels') }}&quot;

      ```

3. Run `dbt run` — the Slack models should be created as part of your next dbt run!
4. Run `dbt test` — we've added useful tests to this project to help if anything goes wrong

## Future improvements
### Next up
- [ ] Improve dbt documentation

### Pending release of v0.17.0
- [ ] Add source vars for schema and database
- [ ] Add instructions for enabling and disabling package sources

