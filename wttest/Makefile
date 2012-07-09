default: bake

bake:
	mkdir -p build
	cd build && cmake -DCMAKE_BUILD_TYPE=Debug .. && VERBOSE=1 make -j3

CMD=build/src/wt_test.wt -c wt_config.xml --docroot '.;/data,/resources' --http-address 0.0.0.0 --http-port 80

run:
	${CMD}

gdb:
	gdb --args ${CMD}

go: bake run
debug: bake gdb
