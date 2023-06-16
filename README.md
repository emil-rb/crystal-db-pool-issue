# Issue

The goal of this is to showcase a weird case in Crystal's db pool handling. Under load the when actively using the pool some fiber "disappear". I assume they are blocked somewhere. We provide two reproductions - one using a simple web interface and load tested using ab (Apache Benchmark) and one using a simple script that just spawns a bunch of fibers and tries to use the pool.

> This only happens when fiddling with the `max_idle_pool_size` param. In this example we want a fixed pool. See `src/db.cr` for details.

# Setup

## Setup database

1. `make create-database` to create an empty database.
2. `make seed` to insert 100000 rows into the films table. See `seed.sql` for details.

## Web

This is a simple reproduction using Kemal and `ab` for load testing.

1. `make run` to start the web server.
2. (in another terminal) `make bench` to run the load test.

We also provide `make run-release` and `make bench-release` to use Crytal's `--release` flag. It reproduces the issue as well, but a bit less often and requires a lot more load to do so.

Look into `src/main.cr` for details.

## In memory

This spawns a lot of fibers making db queries and collects the counts (via another fiber). Usually 1-5 fibers go "missing" and never send on the channel. Of cource, if we skip the DB access everything adds up. Look into `src/inmem.cr` for details. 

Use `make inmem` to run it.