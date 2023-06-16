watch:
	watchexec --restart --clear --exts cr $(MAKE) run
	
watch-release:
	watchexec --restart --clear --exts cr $(MAKE) run-release

inmem:
	crystal run src/inmem.cr

inmem-release:
	crystal run --release src/inmem.cr

run:
	crystal run src/main.cr

run-release:
	crystal run --release src/main.cr

bench:
	ab -c 50 -n 200 http://127.0.0.1:8001/films 2>&1 | tee $@.txt

bench-release:
	ab -c 200 -n 2000 http://127.0.0.1:8001/films 2>&1 | tee $@.txt

bench-jsonl:
	ab -c 50 -n 200 http://127.0.0.1:8001/jsonl 2>&1 | tee $@.txt

bench-jsonl-release:
	ab -c 200 -n 2000 http://127.0.0.1:8001/jsonl 2>&1 | tee $@.txt

create-database:
	psql -c "CREATE DATABASE crystal_load_test;"

seed:
	psql -d crystal_load_test -f seed.sql

pg-console:
	psql -d crystal_load_test

