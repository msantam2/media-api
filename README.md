# Media API

### This API allows consumers to search for & retrieve information regarding movies & TV shows

#### [API Documentation can be found here](https://mediaapi10.docs.apiary.io/#)
(Please note: I am using the free-tier service on Heroku. This means the first request may be slow while the app 'wakes up'. After this, it should be performant for you.)

### Main Details
This is a RESTful API built in Ruby on Rails that serves JSON back to the client. The codebase is stored in GitHub and the live API is hosted on Heroku. Documentation is hosted on Apiary, written in the API Blueprint specification.
There are 3 routes:
- Get movie by ID [Movie Request sample](https://media-api-prod.herokuapp.com/api/movies/5)
- Get show by ID [Show Request sample](https://media-api-prod.herokuapp.com/api/shows/8)
- Search all media by title [Search Request sample](https://media-api-prod.herokuapp.com/api/search?query=king&page[number]=1&page[size]=2)

### Data Details
- The data for this app consists of movies, TV shows, and media types
- The data is fetched from an external API ([The Movie Database](https://www.themoviedb.org/)) and seeded into our PostgreSQL database
- The external API is very robust and well-documented, providing a clean contract that allowed me to model my relational data very effectively
- 300 records of each media type for local development, 500 for production (this number can be easily modified by tweaking the environment variables)
- In order to determine the genres for each media type, I fetch the genre ID's from the external API, and store in a local hash for fast lookup. I then use this data structure to build the 'genres' attribute for each movie & show record.

### Some Programming Decisions
- In order to clean up code in DB seeding operation, I made use of Ruby service objects (found in app/services directory)
- I intentionally didn't wrap seeding operation (when persisting to the DB) in a transaction. If a record fails to save, it's OK, it's not the end of the world. We can tolerate imperfect data at the moment. I didn't experience this issue at all, though.
- Used integers for movie & show ID's, instead of UUID's. Makes for a friendlier request URL. Would most likely use UUID in a bigger, real production app though!

### Deployment Strategy
- Deployed onto Heroku
- Utilized Heroku Pipelines to have a Development, Staging, and Production app.
- Can tweak environment of apps independently of one another
- Performed continuous delivery by integrating with GitHub repo

##### * UPDATE * Additional Deployment Strategy
I also wanted to deploy this API application onto Google Cloud Platform for further fun :)
- Hosted on Google Cloud App Engine
- Integrates with cloud-hosted database: Cloud SQL for PostgreSQL (9.6)
- Worked with correctly allocating traffic to appropriate version of app
- Same API as described in the documentation, except the host is "https://media-api-matt-santa.fun/"
- This host domain above was registered on Namecheap (DNS provider), and verified by Google to point to my App Engine application ("https://media-api-216302.appspot.com/")

### Third-Party Gems Harnessed
- 'rest-client' (for consuming external API)
- 'active_model_serializers' (for cleaner JSON serialization)
- 'pg_search' (for Search endpoint, leveraging postgres full text search)
- 'api-pagination' (wrapper for rendering paginated JSON)
- 'kaminari' (the actual gem performing the pagination)
- 'dotenv-rails' (to easily manage environment variables in local development)
- 'colorize' (to make the seed command CLI nice and pretty - see below :)

### Screenshots

#### Seeding operation
<img src="https://s3.amazonaws.com/media-api-ms/seed-cli.png" width="800" height="500" />

#### Movies in DB
<img src="https://s3.amazonaws.com/media-api-ms/movies-in-db.png" width="600" height="400" />

#### Shows in DB
<img src="https://s3.amazonaws.com/media-api-ms/shows-in-db.png" width="600" height="400" />

#### GET Movie endpoint
<img src="https://s3.amazonaws.com/media-api-ms/get-movie.png" width="600" height="400" />

#### GET Show endpoint
<img src="https://s3.amazonaws.com/media-api-ms/get-show.png" width="600" height="400" />

#### Paginated Search endpoint
<img src="https://s3.amazonaws.com/media-api-ms/paginated-search.png" width="600" height="400" />

#### Heroku Pipeline
<img src="https://s3.amazonaws.com/media-api-ms/heroku-pipeline.png" width="900" height="400" />