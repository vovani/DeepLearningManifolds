WMATCH = wmatch.c pairs.c pointer.c term.c unpairs.c readgraph.c

wmatch: main.o wmatch.o glib.o
	gcc -o wmatch main.o wmatch.o glib.o -lm

$(WMATCH): match.defs

wmatch.o: $(WMATCH)
	gcc -c wmatch.c -lm

clean: 
	rm main.o wmatch.o glib.o wmatch

