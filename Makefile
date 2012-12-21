
bin/x: example/dump-all.m bin/reflection.o
	clang -Isrc -ObjC -fobjc-arc -Wall -Wextra -o $@ $< bin/reflection.o

bin/reflection.o: src/reflection.m src/reflection.h
	clang -Isrc -ObjC -fobjc-arc -Wall -Wextra -c -o $@ $<

