#
# Makefile for forgettinGTD
#
INSTALL_DIR=/usr/local/bin

# Dynamically detect/generate version file as necessary
# This file will define a variable called VERSION.
.PHONY: .FORCE-VERSION-FILE
VERSION-FILE: .FORCE-VERSION-FILE
	@./GEN-VERSION-FILE
-include VERSION-FILE

# Maybe this will include the version in it.
ftd.sh: VERSION-FILE

# For packaging
#ssc DISTFILES := todo.cfg

DISTNAME=ftd_cli-$(VERSION)
dist: $(DISTFILES) ftd.sh
	mkdir -p $(DISTNAME)
	#ssc cp -f $(DISTFILES) $(DISTNAME)/
	sed -e 's/@DEV_VERSION@/'$(VERSION)'/' ftd.sh > $(DISTNAME)/ftd.sh
	tar cf $(DISTNAME).tar $(DISTNAME)/
	gzip -f -9 $(DISTNAME).tar
	zip -9r $(DISTNAME).zip $(DISTNAME)/
	rm -r $(DISTNAME)

.PHONY: clean
clean:
	rm -f $(DISTNAME).tar.gz $(DISTNAME).zip

install:
	install --mode=755 ftd.sh $(INSTALL_DIR)
	#ssc install --mode=644 todo_completion /etc/bash_completion.d/todo
	#ssc mkdir -p /etc/todo
	#ssc [ -e /etc/todo/config ] || \
	#ssc	sed "s/^\(export[ \t]*TODO_DIR=\).*/\1~\/.todo/" todo.cfg > /etc/todo/config
#
# Testing
#
TESTS = $(wildcard tests/t[0-9][0-9][0-9][0-9]-*.sh)
#TEST_OPTIONS=--verbose

test-pre-clean:
	rm -rf tests/test-results "tests/trash directory"*

aggregate-results: $(TESTS)

$(TESTS): test-pre-clean
	-cd tests && ./$(notdir $@) $(TEST_OPTIONS)

test: aggregate-results
	tests/aggregate-results.sh tests/test-results/t*-*
	rm -rf tests/test-results
    
# Force tests to get run every time
.PHONY: test test-pre-clean aggregate-results $(TESTS)
