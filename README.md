### Summary

This repository contains a reproducer demonstrating inefficient SQL that is being generated by the
`latest_verification` accessor in PactBroker::Pacts::PactVersion.  The SQL that seems to be been intended
to be generated was similar to:

`SELECT * from verifications where pact_version_id=6 ORDER BY id desc LIMIT 1`

whereas the actual SQL being generated was

`SELECT * from verifications where pact_version_id=6 ORDER BY id`

When used with a contract/version that has a significant number of verifications, especially ones with large
test results, this results in extraordinary memory growth for the broker and often results in OOM problems.

This reproducer also contains a "fix" demonstrating that it's inefficient SQL causing the problem.  In `config.ru`, there
is a block of commented out code that will override the misbehaving accessor with one that generates the intended SQL.

The pgdump included here includes the sample data with verifications repeated multiple thousands of times to demonstrate the problem.
The restore script will update the test_results to be massive in order to avoid having to commit a massive `pgdump` to git.

### Getting Started

```sh

docker-compose build
docker-compose run pact ./restore.sh
docker-compose-up

curl -s http://localhost:8080/pacticipants/Example%20App/versions/7bd4d9173522826dc3e8704fd62dde0424f4c827
```

That should demonstrate the extreme slowness/memory consumption that is being described.  Uncomment the code in `config.ru` and re-run those steps
and you should observe that memory stays relatively constant and the endpoint responds significantly faster.

The log level is set to `DEBUG` in order to observe the SQL that is being generated, and [MiniProfiler](https://github.com/MiniProfiler/rack-mini-profiler) was set up
for this reproducer as well.  See `http://localhost:8080/?pp-help' for available endpoints.

