#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/gcloud-util.sh"

function main() {
  local -r service_account="capg-controller-manager"
  local -r principal="serviceAccount:${service_account}@${GCP_PROJECT_ID}.iam.gserviceaccount.com"
  local -r role_id="roles/editor"

  create_sa "${service_account}" "${service_account}"
  add_policy_binding "${principal}" "${role_id}"
}

main "$@"
