#
# Makefile
# postgres
# DEBUG OSX: verify /etc/exports using docker-machine-nfs
#

SHELL := /bin/bash
HIDE ?= @
DOCKER_IMAGE ?= onelogin/ruby-saml-example
DOCKER_CONTAINER ?= ruby-saml-example
DOCKER_ENV ?= '-it' # development mode run interactive

-include ./registry/registry.mk

.PHONY: image

image:
	$(HIDE)docker build -t $(DOCKER_IMAGE) .

#
start-dev:
	$(HIDE)docker run --rm $(DOCKER_ENV) --hostname $(DOCKER_CONTAINER)  --name $(DOCKER_CONTAINER) \
	        -p 3003 \
		-v $(PWD):/onelogin/src \
		$(DOCKER_IMAGE)

start:
	$(HIDE)docker run --rm $(DOCKER_ENV) --hostname $(DOCKER_CONTAINER)  --name $(DOCKER_CONTAINER) \
	        -p 3003 \
		-v $(PWD):/onelogin/src \
		--entrypoint /bin/bash \
		$(DOCKER_IMAGE)

enter:
	$(HIDE)docker exec -it $(DOCKER_CONTAINER) /bin/bash

stop:
	-$(HIDE)docker stop $(DOCKER_CONTAINER) $(DOCKER_CONTAINER)-portal
	$(HIDE)docker rm $(DOCKER_CONTAINER) $(DOCKER_CONTAINER)-portal

clean-all:
	#$(HIDE)read -p "This will remove images and containers, continue (y/n)?" -n 1 -r yn;
	-$(HIDE)docker ps -aq | xargs docker stop
	-$(HIDE)docker ps -aq | xargs docker rm
	-$(HIDE)docker images -q| xargs docker rmi
