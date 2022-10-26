#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/gloud-util.sh"

function main() {
  local -r workload_pool_id="${GCP_PROJECT_ID}.svc.id.goog"
  local -r service_account_id="${SERVICE_ACCOUNT}@${GCP_PROJECT_ID}.iam.gserviceaccount.com"
  local -r principal="serviceAccount:${service_account_id}"
  local -r kube_principal="serviceAccount:${workload_pool_id}[${KUBE_NAMESPACE}/${KUBE_SERVICE_ACCOUNT}]"
  local -r workload_identity_user_role="roles/iam.workloadIdentityUser"
  local -r service_account_user_role="roles/iam.serviceAccountUser"

  create_sa "${SERVICE_ACCOUNT}" "${SERVICE_ACCOUNT}"

  # Create kubernetes service account policy binding
  add_sa_policy_binding "${service_account_id}" "${principal}" "${workload_identity_user_role}"

  # Create gcp service acccount project iam policy binding
  add_policy_binding "${kube_principal}" "${service_account_user_role}"
}

main "$@"
