# Hotel Engine Test Service

A small Open API Search test project that utilizes the COVID19 API https://covid19api.com/ for retrieving new (daily) and total confirmed cases by country.

# Installation
To set up the service, run this command: `bin/setup`
## Local Run
To run the service locally, run this command: `bundle exec rails s`

## Planned Tasks:
### Phase 1:
- [x] TASK-1: Setup gems.
- [ ] TASK-2: Cleanup routes.
- [ ] TASK-3: Add service client and parameter casing converters.
- [ ] TASK-4: Add serializers.
- [ ] TASK-5: [Waiting on feedback][Story] Add querying logic.

### Phase 2 [To be planned if there is capacity]:
- Add basic JWT token authentication.
- Add response caching.
- Add performant database queries/design.

### Phase 3 [To be planned if there is capacity]:
- Add pagination.
- Add documentation generation.
- Add asynchronous requests.
