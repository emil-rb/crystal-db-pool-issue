# Issue

The goal of this is to showcase a weird case in Crystal's db pool handling. Under load the when actively using the pool some fiber "disappear". I assume they are blocked somewhere. We provide two reproductions - one using a simple web interface and load tested using ab (Apache Benchmark) and one using a simple script that just spawns a bunch of fibers and tries to use the pool.

# Setup

## DB

1. `make create-database` to create an empty database.
2. `make seed` to insert 100000 rows into the films table. See `seed.sql` for details.

## Web

1. `make run` to start the web server.
2. (in another terminal) `make bench` to run the load test.

We also provide `make run-release` and `make bench-release` to use Crytal's `--release` flag. It reproduces the issue as well, but a bit less often and requires a lot more load to do so.

Look into `src/main.cr` for details.

## In memory

1. `make inmem` to run.

This spawns a lot of fibers making db queries and collects the counts (via another fiber). Usually 1-5 fibers go "missing" and never send on the channel. Of cource, if we skip the DB access everything adds up. Look into `src/inmem.cr` for details.
