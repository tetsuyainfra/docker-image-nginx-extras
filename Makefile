DOCKER_TOUCH_FILE := tmp/.build-docker-image
DOCKER_IMAGE_NAME := nginx-extras

.PHONY: build
ALL: build

clean:
	docker rmi $(DOCKER_IMAGE_NAME):latest || true
	rm -f $(DOCKER_TOUCH_FILE)

clean_cache: clean
	docker builder prune -f

build: $(DOCKER_TOUCH_FILE)

#
# netutils
#
$(DOCKER_TOUCH_FILE): $(wildcard nginx-extras/*)
	docker build \
		--build-arg DOCKER_BASE_IMAGE=debian:trixie \
		--build-arg INSTALL_PACKAGES="nginx nginx-extras libnginx-mod-http-js libnginx-mod-stream-js" \
		-t $(DOCKER_IMAGE_NAME):latest ./nginx-extras
	touch $@

run: $(ACNG_BUILD_FILE)
	docker run --rm -it --name $(DOCKER_IMAGE_NAME) \
		$(DOCKER_IMAGE_NAME):latest bash

cp_package_list: $(ACNG_BUILD_FILE)
	CONTAINER_ID=$$(docker create $(DOCKER_IMAGE_NAME):latest) ; \
	docker container cp $$CONTAINER_ID:/usr/share/rocks/packages.list ./tmp ; \
	docker container rm $$CONTAINER_ID
