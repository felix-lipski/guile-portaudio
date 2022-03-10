scf4: main.scm libsink.so
	guile main.scm

libsink.so: sink.cpp
	g++ -shared -o lib/libsink.so sink.cpp -fPIC -lm -lrt -lasound -ljack -lpthread -lportaudio -largtable3
	
clean:
	rm lib/*
