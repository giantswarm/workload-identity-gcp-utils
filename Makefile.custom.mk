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

.PHONY: all
all: capg-firewall-rule-operator capg-operator cluster-control-plane-node cluster-worker-node csi-driver-app dns-operator-gcp external-dns-app fleet-membership-operator-gcp

.PHONY: capg-firewall-operator
capg-firewall-rule-operator: ensure-gcloud-exists ensure-gcp-envs
	SA_DISPLAY_NAME=capg-firewall-rule-operator \
	KUBE_NAMESPACE=giantswarm \
	KUBE_SERVICE_ACCOUNT=capg-firewall-rule-operator \
	WORKLOAD_IDENTITY_ENABLED=true \
	./scripts/configure-service-account.sh

.PHONY: capg-operator
capg-operator: ensure-gcloud-exists ensure-gcp-envs
	./scripts/configure-capg-operator.sh

.PHONY: cluster-control-plane-node
cluster-control-plane-node: ensure-gcloud-exists ensure-gcp-envs
	SA_DISPLAY_NAME=cluster-control-plane-node \
	./scripts/configure-service-account.sh

.PHONY: cluster-worker-node
cluster-worker-node: ensure-gcloud-exists ensure-gcp-envs
	SA_DISPLAY_NAME=cluster-worker-node \
	./scripts/configure-service-account.sh

.PHONY: csi-driver-app
csi-driver-app: ensure-gcloud-exists ensure-gcp-envs
	SA_DISPLAY_NAME=gcp-compute-persistent-disk-csi-driver-app \
	KUBE_NAMESPACE=kube-system \
	KUBE_SERVICE_ACCOUNT=csi-gce-pd-controller-sa \
	WORKLOAD_IDENTITY_ENABLED=true \
	./scripts/configure-service-account.sh

.PHONY: dns-operator-gcp
dns-operator-gcp: ensure-gcloud-exists ensure-gcp-envs
	SA_DISPLAY_NAME=dns-operator-gcp \
	KUBE_NAMESPACE=giantswarm \
	KUBE_SERVICE_ACCOUNT=dns-operator-gcp \
	WORKLOAD_IDENTITY_ENABLED=true \
	./scripts/configure-service-account.sh

.PHONY: external-dns-app
external-dns-app: ensure-gcloud-exists ensure-gcp-envs
	SA_DISPLAY_NAME=external-dns-app \
	KUBE_NAMESPACE=kube-system \
	KUBE_SERVICE_ACCOUNT=external-dns-app \
	WORKLOAD_IDENTITY_ENABLED=true \
	./scripts/configure-service-account.sh

.PHONY: fleet-membership-operator-gcp
fleet-membership-operator-gcp: ensure-gcloud-exists ensure-gcp-envs
	SA_DISPLAY_NAME=fleet-membership-operator-gcp \
	./scripts/configure-service-account.sh
