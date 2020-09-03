# Hotel Engine Test Service

A small Open API Search test project that utilizes the Open Brewery DB API https://www.openbrewerydb.org/ for retrieving breweries by state and type.

# Installation
To set up the service, run this command: `bin/setup`
## Local Run
To run the service locally, run this command: `bundle exec rails s`

# Documentation [Until official docs are done]:
## GET `/searches`
### Query Params

state: String. State name needs to be lowercase.
- Example:
`http://localhost:3000/searches?state=colorado`

brewery_type: Choose from one of these values: ['micro', 'regional', 'brewpub', 'large', 'planning', 'bar', 'contract', 'proprietor']
- Example:
`http://localhost:3000/searches?brewery_type=micro`

sort_by: Only `name` option.
- Example:
`http://localhost:3000/searches?sort_by=name`

sort_type: Only `asc` or `desc` options.
- Example:
`http://localhost:3000/searches?sort_type=asc`

## Planned Tasks:
### Phase 1:
- [x] TASK-1: Setup gems.
- [x] TASK-2: Cleanup routes.
- [x] TASK-3: Add service client.
- [x] TASK-4: Add querying logic.
- [x] TASK-5: Add serializers.

### Phase 2 [To be planned if there is capacity]:
- [ ] TASK-7: Setup basic JWT token authentication.
- [ ] TASK-8: Setup response caching.
- Add performant database queries/design. Depends on TASK-4.

### Phase 3 [To be planned if there is capacity]:
- Add pagination.
- Add documentation generation.
- Add asynchronous requests.

### Nice to have features:
TASK-6: Add parameter casing converters.

# Caveats
- Since this API is acting as a direct interface to the external API, filtering is handled by utilizing the query parameters on the external API.
