.PHONY: ensure-gcloud-exists
ensure-gcloud-exists:
ifeq  (, $(shell which gcloud))
	$(error "gcloud not found. Please install and initialize. Installation instructions found here - https://cloud.google.com/sdk/docs/install")
endif

.PHONY: ensure-gcp-envs
ensure-gcp-envs:
ifndef GCP_PROJECT_ID
	$(error GCP_PROJECT_ID is undefined)
endif

.PHONY: ensure-kube-envs
ensure-kube-envs:
ifndef SERVICE_ACCOUNT
	$(error SERVICE_ACCOUNT is undefined)
endif
ifndef KUBE_SERVICE_ACCOUNT
	$(error KUBE_SERVICE_ACCOUNT is undefined)
endif
ifndef KUBE_NAMESPACE
	$(error KUBE_NAMESPACE is undefined)
endif

.PHONY: all
all: csi-driver-app setup-workload-identity

.PHONY: csi-driver-app
csi-driver-app: ensure-gcloud-exists ensure-gcp-envs
	./scripts/configure-compute-disk-csi-sa.sh

.PHONY: configure-app-identity
configure-app-identity: ensure-gcloud-exists ensure-kube-envs
	./scripts/configure-app-workload-identity.sh
