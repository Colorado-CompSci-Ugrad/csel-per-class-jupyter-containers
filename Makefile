GCE_PROJECT_NAME=$(shell gcloud config get-value project)
##
## You can use the preceding definition if you're pushing to a dev
## cluster, but normally you should be pushing to the default
##
GCE_PROJECT_NAME=emerald-agility-749
DOCKER_REPO = gcr.io/$(GCE_PROJECT_NAME)

NOTEBOOK_IMAGE = $(DOCKER_REPO)/notebook
NOTEBOOK_VERSION = $(NOTEBOOK_IMAGE):v1.0.42
NOTEBOOK_LATEST = $(NOTEBOOK_IMAGE):latest

build:
	docker build -t $(NOTEBOOK_VERSION) -t $(NOTEBOOK_LATEST) .
	docker tag $(NOTEBOOK_IMAGE) $(NOTEBOOK_VERSION)
	docker tag $(NOTEBOOK_IMAGE) $(NOTEBOOK_LATEST)

tag:
	docker tag $(NOTEBOOK_IMAGE) $(NOTEBOOK_VERSION)
	docker tag $(NOTEBOOK_IMAGE) $(NOTEBOOK_LATEST)

push:
	docker push $(NOTEBOOK_VERSION)
	docker push $(NOTEBOOK_LATEST)
