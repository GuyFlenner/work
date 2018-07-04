# Catalog Project
A Simple API service that gets producer name & return all items that this producer sells.
Built using Ruby on Rails (ver 4.2.5)

# Getting Started
This project use the following external gems/lib/tech:
* resque (https://github.com/resque/resque) to run/queue a task in the background 
* Cron Job (resque_schedule.yml) to schedule a repeated task in the system
* MariaDB (extension of MySQL)
* Fastly CDN (can be any CDN vendor)

# General Info
* Every 1 day, a schedule background job run and create/update the catalog using given CSV file (currently placed on static config folder by can be easily be replace with S3 location on AWS). An improvment can be done if creating additional API that handle delta catalog item create/update so the query will take less time. on my Laptop it took ~1.7 minutes to create the entire 10K+ rows from scretch. if using temp table and replacing the entire content every time, the optimization can be significant improve.
* The end user / service / bot can access & consume the API service using a direct http get call via browser or via console
* An Authentication mechanism was added in order to filter out un authorized users/bots (massive API calls from bots can caused "DOS" if not using CDN)
* A pagination mechanism was added and can be easily control via GET params (see below how to)
* Each result that return to the client is cached in the browser/CDN for 15 minutes (can be any time suggested). this is done using Surrogate-Control key in the request's header.

# API Reference
In order to consume the API service, type the following in the browser:
dev.HOSTNAME/api/v1/catalog/PRODUCER_NAME

Notes:
* PRODUCER_NAME is the name of the producer (if null, the server return error message in the json)
* HOSTNAME = can be also as: localhost:3000 (if using standart rails server)

Additional GET params:
* per_page = X (how many items to display, default = 5)
* page = Y (the paginated page result. 0 if not specified in the header params)

for example: localhost:3000/api/v1/catalog/nestle

# Tests
This project uses the following external gem/tech
* zeus (https://github.com/burke/zeus)
* Seeds (used to prepopulate Test DB tables)
