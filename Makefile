VERSION = 0.2
DISTFILES = Makefile leftree.ml

OCAMLC = ocamlopt
STRIP = strip -s

all: leftree

leftree: leftree.ml
	$(OCAMLC) ${<} -o ${@}
	$(STRIP) ${@}

test: leftree
	./leftree 1 2 3 4 5 6 7 8 9 10
            
clean:
	rm -f leftree{,.cmi,.cmx,.o}

distclean:
	rm -f leftree-$(VERSION).tar.*

dist: distclean
	fakeroot tar cf leftree-$(VERSION).tar $(DISTFILES)
	bzip2 -9 leftree-$(VERSION).tar

.PHONY: all clean distclean dist
