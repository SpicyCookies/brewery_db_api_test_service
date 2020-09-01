# Hotel Engine Test Service

A small Open API Search test project that utilizes the COVID19 API https://covid19api.com/ for retrieving new (daily) and total confirmed cases by country.

# Installation
To set up the service, run this command: `bin/setup`
## Local Run
To run the service locally, run this command: `bundle exec rails s`

## Planned Tasks:
### Phase 1:
- [x] TASK-1: Setup gems.
- [x] TASK-2: Cleanup routes.
- [x] TASK-3: Add service client.
- [ ] TASK-4: [Waiting on feedback][Story] Add querying logic.
- [ ] TASK-5: Add serializers. Depends on TASK-4.
- [ ] TASK-6: Add parameter casing converters. Depends on TASK-4.

### Phase 2 [To be planned if there is capacity]:
- [ ] TASK-7: Setup basic JWT token authentication.
- [ ] TASK-8: Setup response caching.
- Add performant database queries/design. Depends on TASK-4.

### Phase 3 [To be planned if there is capacity]:
- Add pagination.
- Add documentation generation.
- Add asynchronous requests.
