.POSIX:
SHELL = /bin/sh
LUA = lua5.4
LUAC = luac5.4
MAND=mandoc

.PHONY: all build verify ascii man clean install

all: verify

build:
	@mkdir -p build/planmode
	@for f in lib/planmode/*.lua; do \
	  b=$${f##*/}; b=$${b%.lua}; $(LUAC) -s -o build/planmode/$$b.luac "$$f"; \
	done

install: build
	./planmode install

verify: build
	sh -n planmode tools/build_planmode.sh
	find lib tools -type f -name '*.lua' -exec $(LUAC) -p {} \;
	./planmode verify
	$(MAND) -T lint man/planmode.1
	cd framework && $(MAKE) verify

ascii:
	@find . -path ./.git -prune -o -path ./CVS -prune -o -path ./work -prune -o -path ./build -prune -o -path ./framework/build -prune -o -path ./framework/work -prune -o -type f -print | \
	  while IFS= read -r f; do case "$$f" in \
	    *.luac|*.png|*.jpg|*.gif|*.db|*.raw|*.bin|*.pcap) ;; \
	    *) if LC_ALL=C tr '\t' ' ' < "$$f" | grep -Iq '[^ -~]'; then printf 'non-ascii: %s\n' "$$f" >&2; exit 1; fi ;; \
	  esac; done
man:
	$(MAND) -T lint man/planmode.1
	$(MAND) -T ascii man/planmode.1
clean:
	rm -rf work build
	mkdir -p work build
