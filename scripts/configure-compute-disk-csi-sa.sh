#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/gloud-util.sh"

function main() {
  local -r service_account="compute-persistent-disk-csi"
  local -r sa_display_name="gcp-compute-persistent-disk-csi-driver-app"
  local -r principal="serviceAccount:${service_account}@${GCP_PROJECT_ID}.iam.gserviceaccount.com"

  local -r role="gcp_compute_persistent_disk_csi_driver_custom_role"
  local -r role_definition_path="${SCRIPT_DIR}/assets/compute-persistent-disk-csi-driver-role.yaml"
  local -r role_id="projects/${GCP_PROJECT_ID}/roles/${role}"

  create_sa "${service_account}" "${sa_display_name}"
  create_role "${role}" "${role_definition_path}"
  add_policy_binding "${principal}" "${role_id}"
}

main "$@"

