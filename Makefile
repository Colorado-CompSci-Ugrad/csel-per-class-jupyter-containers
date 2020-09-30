GCE_PROJECT_NAME=$(shell gcloud config get-value project)
##
## You can use the preceding definition if you're pushing to a dev
## cluster, but normally you should be pushing to the default
##
GCE_PROJECT_NAME=emerald-agility-749
DEV_LABEL=
ifndef $(DOCKER_REPO)
DOCKER_REPO = gcr.io/$(GCE_PROJECT_NAME)
endif

export NOTEBOOK_BASE = "jupyter/datascience-notebook:lab-2.1.5"

export NOTEBOOK_IMAGE = $(DOCKER_REPO)/notebook$(DEV_LABEL)
export NOTEBOOK_VERSION = $(NOTEBOOK_IMAGE):v1.0.116
export NOTEBOOK_LATEST = $(NOTEBOOK_IMAGE):latest

#
# The base version from which most other images are built
#
export NOTEBOOK_COMMON_BASE=v1.0.116
export NOTEBOOK_COMMON_BASE_AI=v1.0.116
export NOTEBOOK_COMMON_BASE_PL=v1.0.92

export NOTEBOOK_PL_IMAGE = $(DOCKER_REPO)/notebook-pl$(DEV_LABEL)
export NOTEBOOK_PL_VERSION = $(NOTEBOOK_PL_IMAGE):v1.0.116
export NOTEBOOK_PL_LATEST = $(NOTEBOOK_PL_IMAGE):latest

export NOTEBOOK_DB_IMAGE = $(DOCKER_REPO)/notebook-db$(DEV_LABEL)
export NOTEBOOK_DB_VERSION = $(NOTEBOOK_DB_IMAGE):v1.0.116
export NOTEBOOK_DB_LATEST = $(NOTEBOOK_DB_IMAGE):latest

export NOTEBOOK_MPI_IMAGE = $(DOCKER_REPO)/notebook-mpi$(DEV_LABEL)
export NOTEBOOK_MPI_VERSION = $(NOTEBOOK_MPI_IMAGE):v1.0.116
export NOTEBOOK_MPI_LATEST = $(NOTEBOOK_MPI_IMAGE):latest

export NOTEBOOK_AI_IMAGE = $(DOCKER_REPO)/notebook-ai$(DEV_LABEL)
export NOTEBOOK_AI_VERSION = $(NOTEBOOK_AI_IMAGE):v1.0.116
export NOTEBOOK_AI_LATEST = $(NOTEBOOK_AI_IMAGE):latest

export NOTEBOOK_CHAOS_IMAGE = $(DOCKER_REPO)/notebook-chaos$(DEV_LABEL)
export NOTEBOOK_CHAOS_VERSION = $(NOTEBOOK_CHAOS_IMAGE):v1.0.116
export NOTEBOOK_CHAOS_LATEST = $(NOTEBOOK_CHAOS_IMAGE):latest

export NOTEBOOK_DC_IMAGE = $(DOCKER_REPO)/notebook-dc$(DEV_LABEL)
export NOTEBOOK_DC_VERSION = $(NOTEBOOK_DC_IMAGE):v1.0.119
export NOTEBOOK_DC_LATEST = $(NOTEBOOK_DC_IMAGE):latest

export NOTEBOOK_PAC_IMAGE = $(DOCKER_REPO)/notebook-pac$(DEV_LABEL)
export NOTEBOOK_PAC_VERSION = $(NOTEBOOK_PAC_IMAGE):v1.0.117
export NOTEBOOK_PAC_LATEST = $(NOTEBOOK_PAC_IMAGE):latest

build: build-notebook build-pl build-db build-mpi build-ai build-chaos build-dc build-pac

DOCKER_ARGS=--build-arg DEV_LABEL=$(DEV_LABEL)

build-notebook:
	docker build --build-arg BASE_CONTAINER="$(NOTEBOOK_BASE)" \
		-t $(NOTEBOOK_VERSION) -t $(NOTEBOOK_LATEST) -f Dockerfile .
	docker tag $(NOTEBOOK_IMAGE) $(NOTEBOOK_VERSION)
	docker tag $(NOTEBOOK_IMAGE) $(NOTEBOOK_LATEST)

build-pl:
	docker build --build-arg BASE_CONTAINER="$(NOTEBOOK_IMAGE):$(NOTEBOOK_COMMON_BASE_AI)" \
		$(DOCKER_ARGS) -t $(NOTEBOOK_PL_VERSION) -t $(NOTEBOOK_PL_LATEST) -f Dockerfile-pl .
	docker tag $(NOTEBOOK_PL_IMAGE) $(NOTEBOOK_PL_VERSION)
	docker tag $(NOTEBOOK_PL_IMAGE) $(NOTEBOOK_PL_LATEST)

build-db:
	docker build --build-arg BASE_CONTAINER="$(NOTEBOOK_IMAGE):$(NOTEBOOK_COMMON_BASE)" \
		$(DOCKER_ARGS) -t $(NOTEBOOK_DB_VERSION) -t $(NOTEBOOK_DB_LATEST) -f Dockerfile-db .
	docker tag $(NOTEBOOK_DB_IMAGE) $(NOTEBOOK_DB_VERSION)
	docker tag $(NOTEBOOK_DB_IMAGE) $(NOTEBOOK_DB_LATEST)

build-mpi:
	docker  build --build-arg BASE_CONTAINER="$(NOTEBOOK_IMAGE):$(NOTEBOOK_COMMON_BASE)" \
		$(DOCKER_ARGS) -t $(NOTEBOOK_MPI_VERSION) -t $(NOTEBOOK_MPI_LATEST) -f Dockerfile-mpi .
	docker tag $(NOTEBOOK_MPI_IMAGE) $(NOTEBOOK_MPI_VERSION)
	docker tag $(NOTEBOOK_MPI_IMAGE) $(NOTEBOOK_MPI_LATEST)

build-ai:
	docker build --build-arg BASE_CONTAINER="$(NOTEBOOK_IMAGE):$(NOTEBOOK_COMMON_BASE_AI)" \
		-t $(NOTEBOOK_AI_VERSION) -t $(NOTEBOOK_AI_LATEST) -f Dockerfile-ai .
	docker tag $(NOTEBOOK_AI_IMAGE) $(NOTEBOOK_AI_VERSION)
	docker tag $(NOTEBOOK_AI_IMAGE) $(NOTEBOOK_AI_LATEST)

build-chaos:
	docker build --build-arg BASE_CONTAINER="$(NOTEBOOK_IMAGE):$(NOTEBOOK_COMMON_BASE)" \
		$(DOCKER_ARGS) -t $(NOTEBOOK_CHAOS_VERSION) -t $(NOTEBOOK_CHAOS_LATEST) -f Dockerfile-chaos .
	docker tag $(NOTEBOOK_CHAOS_IMAGE) $(NOTEBOOK_CHAOS_VERSION)
	docker tag $(NOTEBOOK_CHAOS_IMAGE) $(NOTEBOOK_CHAOS_LATEST)

build-dc:
	docker build --build-arg BASE_CONTAINER="$(NOTEBOOK_IMAGE):$(NOTEBOOK_COMMON_BASE)" \
		$(DOCKER_ARGS) -t $(NOTEBOOK_DC_VERSION) -t $(NOTEBOOK_DC_LATEST) -f Dockerfile-dc .
	docker tag $(NOTEBOOK_DC_IMAGE) $(NOTEBOOK_DC_VERSION)
	docker tag $(NOTEBOOK_DC_IMAGE) $(NOTEBOOK_DC_LATEST)

build-pac:
	docker build --build-arg BASE_CONTAINER="$(NOTEBOOK_IMAGE):$(NOTEBOOK_COMMON_BASE)" \
		$(DOCKER_ARGS) -t $(NOTEBOOK_PAC_VERSION) -t $(NOTEBOOK_PAC_LATEST) -f Dockerfile-pac .
	docker tag $(NOTEBOOK_PAC_IMAGE) $(NOTEBOOK_PAC_VERSION)
	docker tag $(NOTEBOOK_PAC_IMAGE) $(NOTEBOOK_PAC_LATEST)



tag:
	-docker tag $(NOTEBOOK_IMAGE) $(NOTEBOOK_VERSION)
	-docker tag $(NOTEBOOK_IMAGE) $(NOTEBOOK_LATEST)
	-docker tag $(NOTEBOOK_PL_IMAGE) $(NOTEBOOK_PL_VERSION)
	-docker tag $(NOTEBOOK_PL_IMAGE) $(NOTEBOOK_PL_LATEST)
	-docker tag $(NOTEBOOK_DB_IMAGE) $(NOTEBOOK_DB_VERSION)
	-docker tag $(NOTEBOOK_DB_IMAGE) $(NOTEBOOK_DB_LATEST)
	-docker tag $(NOTEBOOK_MPI_IMAGE) $(NOTEBOOK_MPI_VERSION)
	-docker tag $(NOTEBOOK_MPI_IMAGE) $(NOTEBOOK_MPI_LATEST)
	-docker tag $(NOTEBOOK_AI_IMAGE) $(NOTEBOOK_AI_VERSION)
	-docker tag $(NOTEBOOK_AI_IMAGE) $(NOTEBOOK_AI_LATEST)
	-docker tag $(NOTEBOOK_CHAOS_IMAGE) $(NOTEBOOK_CHAOS_VERSION)
	-docker tag $(NOTEBOOK_CHAOS_IMAGE) $(NOTEBOOK_CHAOS_LATEST)
	-docker tag $(NOTEBOOK_DC_IMAGE) $(NOTEBOOK_DC_VERSION)
	-docker tag $(NOTEBOOK_DC_IMAGE) $(NOTEBOOK_DC_LATEST)
	-docker tag $(NOTEBOOK_PAC_IMAGE) $(NOTEBOOK_PAC_VERSION)
	-docker tag $(NOTEBOOK_PAC_IMAGE) $(NOTEBOOK_PAC_LATEST)


push: push-notebook push-pl push-db push-mpi push-ai push-chaos push-dc push-pac

push-notebook: build-notebook
	-docker push $(NOTEBOOK_VERSION)
	-docker push $(NOTEBOOK_LATEST)

push-pl: build-pl
	-docker push $(NOTEBOOK_PL_VERSION)
	-docker push $(NOTEBOOK_PL_LATEST)

push-db: build-db
	-docker push $(NOTEBOOK_DB_VERSION)
	-docker push $(NOTEBOOK_DB_LATEST)

push-mpi:build-mpi
	-docker push $(NOTEBOOK_MPI_VERSION)
	-docker push $(NOTEBOOK_MPI_LATEST)

push-ai: build-ai
	-docker push $(NOTEBOOK_AI_VERSION)
	-docker push $(NOTEBOOK_AI_LATEST)

push-chaos: build-chaos
	-docker push $(NOTEBOOK_CHAOS_VERSION)
	-docker push $(NOTEBOOK_CHAOS_LATEST)

push-dc: build-dc
	-docker push $(NOTEBOOK_DC_VERSION)
	-docker push $(NOTEBOOK_DC_LATEST)

push-pac: build-pac
	-docker push $(NOTEBOOK_PAC_VERSION)
	-docker push $(NOTEBOOK_PAC_LATEST)
