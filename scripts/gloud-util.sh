#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

function create_sa(){
  local name=$1
  local display_name=$2

  echo "========> Creating ${name} service account"

  set -x +e
  gcloud iam service-accounts create $name \
    --display-name="${display_name}" \
    --project=${GCP_PROJECT_ID}

  { set +x -e; } 2>/dev/null
}

function create_role() {
  local name=$1
  local file_path=$2

  echo "========> Creating ${name} role using definition in ${file_path}"

  set -x +e
  gcloud iam roles create $name \
    --file=${file_path} \
    --project=${GCP_PROJECT_ID}

  { set +x -e; } 2>/dev/null
}

#######################################
# Adds a project level IAM policy binding between a service account and role
# Arguments:
#   - The principal to add the binding for. Should be of the form user|group|serviceAccount:email or domain:domain.
#     Examples: user:test-user@gmail.com, group:admins@example.com, serviceAccount:test123@example.domain.com, or domain:example.domain.com.
#
#   - The role ID. Should be in the form projects/<project_id>/roles/<name>
#######################################

function add_policy_binding() {
  local principal=$1
  local role_id=$2

  echo "========> Adding iam policy binding"

  set -x
  gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
    --member "${principal}" \
    --role "${role_id}"

  { set +x; } 2>/dev/null
}

#######################################
# Adds a service account IAM policy binding
# Arguments:
#   - The service account ID or fully qualified identifier for the service account
#
#   - The principal to add the binding for. Should be of the form user|group|serviceAccount:email or domain:domain.
#     Examples: user:test-user@gmail.com, group:admins@example.com, serviceAccount:test123@example.domain.com, or domain:example.domain.com.
#
#   - The role ID. Should be in the form projects/<project_id>/roles/<name>
#######################################

function add_sa_policy_binding() {
  local service_account_id=$1
  local principal=$2
  local role_id=$3

  echo "========> Adding iam policy binding"

  set -x
  gcloud iam service-accounts add-iam-policy-binding \
    --project ${GCP_PROJECT_ID} \
    ${service_account_id} \
    --member "${principal}" \
    --role "${role_id}"

  { set +x; } 2>/dev/null
}

