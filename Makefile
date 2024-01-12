NAME := maildev
TAG := latest
IMAGE_NAME := panubo/$(NAME)

.PHONY: help bash run run-dkim run-all-dkim build push clean

help:
	@printf "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)\n"

bash: ## Runs a bash shell in the docker image
	docker run --rm -it -e MAILNAME=mail.example.com $(IMAGE_NAME):$(TAG) bash

run: ## Runs the docker image in a test mode
	$(eval ID := $(shell docker rm -f $(NAME) >/dev/null 1>&2; docker run -d -p 8080:80 --name $(NAME) \
		--hostname maildev.example.com \
		-e MAILNAME=maildev.example.com \
		-e SIZELIMIT=20480000 \
		-e POSTCONF=disable_dns_lookups=yes \
		$(IMAGE_NAME):$(TAG)))
	$(eval IP := $(shell docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${ID}))
	@echo "Running ${ID} @ smtp://${IP}"
	@docker attach ${ID}
	@docker kill ${ID}

build: ## Builds docker image latest
	docker build --pull -t $(IMAGE_NAME):$(TAG) .

push: ## Pushes the docker image to hub.docker.com
	docker push $(IMAGE_NAME):$(TAG)

clean: ## Remove built image
	docker rmi $(IMAGE_NAME):$(TAG)
