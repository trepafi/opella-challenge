# Challenge Summary

## What Was Built

Azure infrastructure provisioned with Terraform, structured for multi-environment deployment with CI/CD automation.

## Reusable VNET Module (`modules/vnet/`)

Terraform module that provisions a Virtual Network with configurable subnets and Network Security Groups. Each subnet gets an NSG with a secure-by-default baseline (deny all inbound, allow all outbound) plus optional custom rules. Documentation is auto-generated via `terraform-docs`.

## Environments (`environments/dev/`, `environments/prod/`)

Two environments consuming the VNET module:

| | Dev | Prod |
|---|---|---|
| Region | eastus | westeurope |
| VNET CIDR | 10.0.0.0/16 | 10.1.0.0/16 |
| Storage replication | LRS | GRS |

Each environment provisions: Resource Group, VNET, Subnets, NSGs, Linux VM (Ubuntu 22.04, SSH-only auth), Public IP, Storage Account with blob container.

All resources follow the naming convention `{type}-{project}-{env}-{region}` and are tagged with `environment`, `project`, `owner`, and `managed_by`.

## Remote State (`scripts/bootstrap-state.sh`)

Terraform state stored in Azure Blob Storage (`stopellatfstatelubert`) with per-environment state files. Bootstrap script provisions the storage account.

## CI/CD (`.github/workflows/`)

- **Terraform Plan** — runs automatically on push (dev) and PRs (dev + prod). Includes format check, validate, TFLint, Checkov, and plan.
- **Terraform Apply** — triggered manually via `workflow_dispatch` with environment selector.

See [GHubActions.md](GHubActions.md) for details and proof of execution.

## Code Quality

- **Pre-commit hooks**: `terraform fmt`, `terraform validate`, `terraform-docs`, `tflint`, `checkov`
- **TFLint**: Azure ruleset with naming convention and documentation rules
- **Checkov**: Static security scanning integrated in CI
