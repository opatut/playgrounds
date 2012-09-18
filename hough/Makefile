build:
	dmd -g -debug -op -Iderp/ -Iderp/externals/LuaD/ -Iderp/externals/orange -Iderp/externals/Derelict3/import/ -Iderp/externals/gl3n/import/ -Iderp//home/paul/src/prj/derp -Iderp/externals/LuaD/ -Iderp/externals/Derelict3/import/ -Iderp/externals/gl3n/import/ -L-Lderp/externals/LuaD/lib -L-Lderp/externals/orange/lib/64/ -L-Lderp/externals/orange/lib/32/ -L-Lderp/externals/Derelict3/lib/ -L-Lderp/externals/gl3n/lib -L-Lderp/lib/ -L-Lderp/externals/LuaD/lib -L-Lderp/externals/Derelict3/lib/ -L-Lderp/externals/gl3n/lib -L-lluajit-5.1 -L-ldl -L-lcurl -L-lluad -L-lorange -L-lDerelictAL -L-lDerelictFT -L-lDerelictGL3 -L-lDerelictGLFW3 -L-lDerelictIL -L-lDerelictUtil -L-lgl3n-dmd -L-lderp -L-lluad -L-lDerelictAL -L-lDerelictASSIMP -L-lDerelictFT -L-lDerelictGL3 -L-lDerelictGLFW3 -L-lDerelictIL -L-lDerelictUtil -L-lgl3n-dmd -ofhough.bin hough.d

run:
	./hough.bin

go: build run

default: go
