#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly SA_DISPLAY_NAME="${SA_DISPLAY_NAME:?SA_DISPLAY_NAME not set or empty}"
readonly SERVICE_ACCOUNT="${SA_DISPLAY_NAME:0:30}"
readonly WORKLOAD_IDENTITY_ENABLED=${WORKLOAD_IDENTITY_ENABLED:-false}

if $WORKLOAD_IDENTITY_ENABLED; then
  readonly KUBE_NAMESPACE="${KUBE_NAMESPACE:?KUBE_NAMESPACE not set or empty}"
  readonly KUBE_SERVICE_ACCOUNT="${KUBE_SERVICE_ACCOUNT:?KUBE_SERVICE_ACCOUNT not set or empty}"
fi

readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/gcloud-util.sh"

function main() {
  local -r principal="serviceAccount:${SERVICE_ACCOUNT}@${GCP_PROJECT_ID}.iam.gserviceaccount.com"

  create_sa "${SERVICE_ACCOUNT}" "${SA_DISPLAY_NAME}"
  add_custom_role "${principal}"
  if $WORKLOAD_IDENTITY_ENABLED; then
    add_workload_identity_role "$SERVICE_ACCOUNT" "$KUBE_NAMESPACE" "$KUBE_SERVICE_ACCOUNT"
  fi
}

function add_custom_role() {
  local pricipal="$1"

  local -r sanitized_display_name="$(echo $SA_DISPLAY_NAME | sed 's/-/_/g')"
  local -r role="${sanitized_display_name}_custom_role"
  local -r role_definition_path="${SCRIPT_DIR}/assets/${role}.yaml"
  local -r role_id="projects/${GCP_PROJECT_ID}/roles/${role}"

  create_role "${role}" "${role_definition_path}"
  add_policy_binding "${principal}" "${role_id}"
}

main "$@"
