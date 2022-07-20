[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=1.x&color=orange)

# Claims Preprocessing

Check out the [Claims Preprocessing Data Model](https://docs.google.com/spreadsheets/d/1NuMEhcx6D6MSyZEQ6yk0LWU0HLvaeVma8S-5zhOnbcE/edit#gid=1991587675)

Check out our [Docs](http://thetuvaproject.com/)

Claims preprocessing enhances medical claims data to make it useful for analytics.  It is done by:

- Assigning encounter types to individual claim lines based on the bill type code and or revenue code of institutional claims 
and the place of service code of professional claims.
- Grouping individual claims into encounters (this involves logic to, for example, merge claims with overlapping dates or 
adjacent dates into a single inpatient stay).
- Crosswalking professional claims to institutional encounters.


## Pre-requisites
1. You have claims data (e.g. medicare, medicaid, or commercial) in a data warehouse
2. You have mapped your claims data to the [claim input layer](https://docs.google.com/spreadsheets/d/1NuMEhcx6D6MSyZEQ6yk0LWU0HLvaeVma8S-5zhOnbcE/edit?usp=sharing)
    - The claim input layer is at a claim line level and each claim id and claim line number is unique
    - The eligibility input layer is unique at the month/year grain per patient and payer
    - Revenue code is 4 digits in length
2. You have [dbt](https://www.getdbt.com/) installed and configured (i.e. connected to your data warehouse)

[Here](https://docs.getdbt.com/dbt-cli/installation) are instructions for installing dbt.

## Getting Started
Complete the following steps to configure the package to run in your environment.

1. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this repo to your local machine or environment
2. Create a database called 'tuva' in your data warehouse
    - Note: this is optional, see step 4 for further detail
3. Configure [dbt_project.yml](/dbt_project.yml)
    - Fill in vars (variables):
        - source_name - description of the dataset feeding this project
        - input_database - database where sources feeding this project are stored
        - input_schema - schema where sources feeding this project is stored
        - output_database - database where output of this project should be written.  
        We suggest using the Tuva database but any database will work.
        - output_schema - name of the schema where output of this project should be written
4. Review [sources.yml](/sources.yml)
The table names listed are the same as in the Tuva data model (linked above).  If you decided to rename these tables:
    - Update table names in sources.yml
    - Update table name in medical_claim and eligibility jinja function
5. Execute `dbt build` to load seed files, run models, and perform tests.

## Contributions
Have an opinion on the mappings? Notice any bugs when installing and running the package? 
If so, we highly encourage and welcome contributions! 

Join the conversation on [Slack](https://tuvahealth.slack.com/ssb/redirect#/shared-invite/email)!  We'd love to hear from you on the #claims-preprocessing channel.

## Database Support
This package has been written for Snowflake.  Redshift is available [here](https://github.com/thutuva/claims_preprocessing_redshift)
