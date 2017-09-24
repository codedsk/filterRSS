PROJECT = filterRSS_lebatard
VIRTUAL_ENV = env
FUNCTION_NAME = filterRSS
AWS_REGION = us-east-1
FUNCTION_HANDLER = lambda_handler
LAMBDA_ROLE =
PACKAGE_DIR = ./package

all: virtual clean_package build_package_tmp copy_python remove_unused zip

distclean:
	rm -rf $(VIRTUAL_ENV) $(PACKAGE_DIR)

# you need to have virtualenv in you path
#   pip install virtualenv
# to install globally or
#   pip install --user virtualenv
# to install locally, then make sure ~/.local/bin in in your PATH

virtual:
	@echo "--> Setup and activate virtualenv"
	if test ! -d "$(VIRTUAL_ENV)"; then \
	  pip install --user virtualenv; \
	  virtualenv --no-site-packages $(VIRTUAL_ENV); \
	  . $(VIRTUAL_ENV)/bin/activate; \
	  pip install PyRSS2Gen; \
	  pip install feedparser; \
	  deactivate; \
	fi
	@echo ""

clean_package:
	rm -rf $(PACKAGE_DIR)/*

build_package_tmp:
	mkdir -p $(PACKAGE_DIR)/tmp/lib
	cp -a ./$(PROJECT)/. $(PACKAGE_DIR)/tmp/

copy_python:
	if test -d $(VIRTUAL_ENV)/lib; then \
	  cp -a $(VIRTUAL_ENV)/lib/python2.7/site-packages/. $(PACKAGE_DIR)/tmp/; \
	fi
	if test -d $(VIRTUAL_ENV)/lib64; then \
	  cp -a $(VIRTUAL_ENV)/lib64/python2.7/site-packages/. $(PACKAGE_DIR)/tmp/; \
	fi

remove_unused:
	rm -rf $(PACKAGE_DIR)/tmp/easy_install*
	rm -rf $(PACKAGE_DIR)/tmp/pip*
	rm -rf $(PACKAGE_DIR)/tmp/setuptools*
	rm -rf $(PACKAGE_DIR)/tmp/wheel*

zip:
	cd $(PACKAGE_DIR)/tmp && zip -r ../$(PROJECT).zip .
