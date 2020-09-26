# Brewery DB API Test Service

A small Open API Search test project that utilizes the Open Brewery DB API https://www.openbrewerydb.org/ for retrieving breweries by state and type. This was a project done as part of the interview process for Hotel Engine.

### IMPORTANT NOTES: 
* This project was built in a week. The design was hastily planned.
* I am not planning on updating this project. This project will be utilized as a resource.

# Installation
To set up the service, run this command: `bin/setup`
## Local Run
To run the service locally, run this command: `bundle exec rails s`

# Documentation:
## GET `/searches`
### Description
Endpoint for searching for breweries.

### Query Params

state: String.
- Example:
`http://localhost:3000/searches?state=new york`

brewery_type: String. Choose from one of these values: ['micro', 'regional', 'brewpub', 'large', 'planning', 'bar', 'contract', 'proprietor']
- Example:
`http://localhost:3000/searches?brewery_type=micro`

sort_by: String. Only `name` option.
- Example:
`http://localhost:3000/searches?sort_by=name`

sort_type: String. Only `asc` or `desc` options. Default is `asc`.
- Example:
`http://localhost:3000/searches?sort_type=asc`

## DELETE `/searches/clear`
### Description
Endpoint for clearing searches.

## Postman Request Screenshots
See PR: https://github.com/SpicyCookies/hotel_engine_test_service/pull/4#issue-479290760

# Planned Tasks:
## Phase 1:
- [x] TASK-1: Setup gems.
- [x] TASK-2: Cleanup routes.
- [x] TASK-3: Add service client.
- [x] TASK-4: Add querying logic.
- [x] TASK-5: Add serializers.
- [x] TASK-9 Cleanup and validations
- [x] PATCH-1: Fixed Heroku deploy bug

## Phase 2 [Friday deadline, going to just explain how I could possibly implement]:
- Setup basic JWT token authentication.
  - How to implement:
    - I've implemented a basic JWT token authentication in another project: https://github.com/SpicyCookies/cookie_points_service/pull/1
      - I was planning on migrating some of that code over to this project.
- Setup response caching.
  - Note: The Brewery API responses are "cached", in that they are stored as breweries in `Search`.
  - How to implement:
    - I was thinking either Action Level Caching: https://devcenter.heroku.com/articles/caching-strategies#action-caching.
    or
    - A basic Filestore cache around https://github.com/SpicyCookies/hotel_engine_test_service/blob/master/app/controllers/searches_controller.rb#L30-L49
    - Example config: https://guides.rubyonrails.org/caching_with_rails.html#activesupport-cache-filestore
    - Example implementation:
    ```ruby
    Rails.cache.fetch("#{state_param}_#{brewery_type_param}", expires_in: 1.minutes) do
      ...breweries...
    end
    ```
- Add performant database queries/design.
  - Note:
    - Added some indexing. The design I went with had a basic `Search` with many `Brewery` children.

## Phase 3 [Friday deadline, going to just explain how I could possibly implement]:
- Add pagination.
  - How to implement:
    - Use the Kaminari gem: https://github.com/kaminari/kaminari
    - https://github.com/SpicyCookies/hotel_engine_test_service/blob/master/app/controllers/searches_controller.rb#L54
    - Example:
    ```ruby
    paginated_breweries = result_breweries.page(params[:page]).per(params[:limit])
    
    render status: :ok, 
           json: { breweries: paginated_breweries, meta: { total_pages: paginated_breweries.total_pages, total: paginated_breweries.total_count } }, 
           each_serializer: BrewerySerializer
    ```
- Add documentation generation.
  - How to implement:
    - Utilize RSwag gem for generating swagger docs: https://github.com/rswag/rswag
      - Would probably require re-working of request specs. Doesn't seem fun with their DSL.
- Add asynchronous requests.
  - I haven't worked with async requests at work at all. The implementation is what I got from reading around.
  - How to implement:
    - Using Sidekiq and Redis to queue a job.
    - Adding an endpoint on the Rails API for polling the job id and updating Search breweries when the job is done.

## Nice to have features:
- Users being able to keep their own searches. Add a column to the Searches table with user_ids and modify querying to lookup by user_ids too.
- Add parameter casing converters. I'm more used to the camelCasing convention for request and response bodies.
- Swagger documentation.

# Caveats
- Since this API is acting as a direct interface to the external Brewery API, filtering is handled by utilizing the query parameters on the external API.
- The external Brewery API has a result default of 20 breweries, so just a GET index `/searches` without query parameters won't return all breweries everywhere, only 20.
- Rushed commits near the last couple commits.
- Originally chose another external API to work with, swapped to the external Brewery API, as it worked better with the design I had.

 
