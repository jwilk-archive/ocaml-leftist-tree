OCAMLC = ocamlopt

all: leftree

leftree: leftree.ml
	$(OCAMLC) ${<} -o ${@}

test: leftree
	./leftree 1 2 3 4 5 6 7 8 9 10
            
clean:
	rm -f leftree leftree.cmi leftree.cmx leftree.o

.PHONY: all clean distclean dist

# vim:ts=4 sts=4 sw=4 noet
