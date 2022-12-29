# Installation

This doc covers all of the steps required to connect your GCP Project with Enforce.

## Prerequisites

You will need to have the following tools installed on your machine:
* [chainctl](https://edu.chainguard.dev/chainguard/chainguard-enforce/how-to-install-chainctl/)
* [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Installation Steps

Complete the following steps to correctly setup account association between Enforce and your GCP project.

### Connect your GCP project to Enforce using chainctl

First, you'll need to connect your GCP project to Enforce using the [chainctl](https://edu.chainguard.dev/chainguard/chainguard-enforce/how-to-install-chainctl/) CLI:

First, set the following environment variables for your Enforce Group ID and GCP Project details:

```
export ENFORCE_GROUP_ID="<<uidp of target Enforce IAM group>>" # You can get the ID by running 'chainctl iam groups describe GROUP_NAME'
export GCP_PROJECT_NUMBER="<< project number >>"
export GCP_PROJECT_ID="<< project id >>"
```

Then, connect your GCP Project details with Enforce:
```
chainctl iam group set-gcp $ENFORCE_GROUP_ID \
  --project-number $GCP_PROJECT_NUMBER \
  --project-id $GCP_PROJECT_ID
```

### Apply this Terraform Module

Next, you'll need to apply the contents of this Terraform module to your GCP project.

First, clone this repository and enter it:

```
git clone https://github.com/chainguard-dev/terraform-google-chainguard-account-association.git
cd terraform-google-chainguard-account-association
```

Next you'll initialize the terraform module.
At the moment it is configured to store terraform state locally, if you'd like to store state remotely you can set up a [backend](https://developer.hashicorp.com/terraform/language/settings/backends/configuration) before running any terraform commands.

Initialize the module:

```
terraform init
```

Then run `terraform plan` on the module and confirm the expected changes are acceptable:

```
terraform plan --var enforce_group_id=$ENFORCE_GROUP_ID --var google_project_id=$GCP_PROJECT_ID
```

Finally, run `terraform apply` to apply the module to your GCP project:

```
terraform apply --var enforce_group_id=$ENFORCE_GROUP_ID --var google_project_id=$GCP_PROJECT_ID
```

This should create a Workload Identity Pool in your GCP project alongside several service accounts Enforce will use to access your project.

### Confirm Account Association is Set Up Correctly
Finally, you can confirm account association has been set up correctly with chainctl:

```
chainctl iam groups check-gcp $ENFORCE_GROUP_ID
                        
2022/12/28 20:54:57 GCP role impersonation was successful!
```

If everything is working correctly you should see a message like the one above!
