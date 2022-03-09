scf4: main.scm libsink.so
	guile main.scm
	# alacritty --hold --command ./sink
	# alacritty --hold --command ./sink --input-type double & ./writer
	# alacritty --hold --command ./sink & ./writer

sink: sink.cpp
	g++ -o sink sink.cpp -lm -lrt -lasound -ljack -lpthread -lportaudio -largtable3

libsink.so: sink.cpp
	g++ -shared -o lib/libsink.so sink.cpp -lm -lrt -lasound -ljack -lpthread -lportaudio -largtable3

writer: writer.c
	gcc -o writer writer.c -lm

	
clean:
	rm sink writer *.pipe lib/libsink.so
