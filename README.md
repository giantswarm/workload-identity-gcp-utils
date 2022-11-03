# workload-identity-gcp-utils

A collection of scripts to help you configure and use workload identity on GCP.

## Usage

### Prerequisites 

1. Install [gcloud cli](https://cloud.google.com/sdk/docs/install)
1. Run `gcloud auth login`
1. Make sure you log in with a user that has the permissions to create service
   accounts, roles and assing roles to service accounts on the project level as
   well as assign service account users.

### Installing everything

To install all service accounts simply run:
```sh
GCP_PROJECT=<your-project-id> make all
```

_NOTE:_ You can also just export the `GCP_PROJECT` env var instead of passing it to each make call.

### Install specific service account

You can install a specific service account by calling it's make target. To get a list of all available targets run `make help`
```sh
GCP_PROJECT=<your-project-id> make <some-service-account-target>
```
