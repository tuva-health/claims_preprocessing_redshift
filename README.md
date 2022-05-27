[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=1.x&color=orange)

# Claim Preprocessing

Check out the [Claims Preprocessing Google Sheet](https://docs.google.com/spreadsheets/d/1TMMM1u8GTdWqxGcHALRtGMjcxBXQwBbWUW8pHL66W_E/edit#gid=245639858)

Check out our [Docs](http://thetuvaproject.com/)

Our claims pre-processing engine starts from an input layer containing standard data elements from raw claims datasets and processes the claims to make them useful for analysis.  It is done by:

- Doing adjustments and reversals
- Assigning encounter types to individual claim lines based on logic involving Bill Type Code, Place of Service Code, Revenue Code, etc. (we defined a list of ~20 encounter types that are relevant for downstream analytics, for example: acute inpatient, office visit, ED, SNF, home health, dialysis, telehealth, hospice, etc.)
- Grouping individual claims into encounters (this involves logic to, for example, merge claims with overlapping dates or adjacent dates into a single inpatient stay)
- Rolling up professional claims into encounters defined from merged institutional claims


## Pre-requisites
1. You have claims data (CCLF, SAF, commercial) in a data warehouse mapped to the Tuva input layer (reference Google sheet linked above)
    - The input layer is at a claim line level
    - Revenue code is 4 digits in length
2. You have [dbt](https://www.getdbt.com/) installed and configured (i.e. connected to your data warehouse)

[Here](https://docs.getdbt.com/dbt-cli/installation) are instructions for installing dbt.

## Configuration
Execute the following steps to load all seed files, build all data marts, and run all data quality tests in your data warehouse:

1. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this repo to your local machine or environment
2. Create a database called 'tuva' in your data warehouse
    - note: this is where data from the project will be generated
3. Create source data tables in your data warehouse
    - note: these tables must match table names and column names exactly as in [source.yml](models/source.yml)
4. Configure [dbt_project.yml](/dbt_project.yml)
    - profile: set to 'tuva' by default - change this to an active profile in the profile.yml file that connects to your data warehouse
    - vars: configure source_name, source database name, and source schema name
5. Run project
    1. Navigate to the project directory in the command line
    2. Execute "dbt build" to create all tables/views in your data warehouse

## Contributions
Have an opinion on the mappings? Notice any bugs when installing 
and running the package? If so, we highly encourage and welcome contributions to this package! 

Join the conversation on [Slack](https://tuvahealth.slack.com/ssb/redirect#/shared-invite/email)!  We'd love to hear from you on the #claims-preprocessing channel.

## Database Support
This package has been tested on Redshift.  We are planning to expand testing to BigQuery in the near future.
