# iac_itarlz

Lightweight, opinionated Azure Landing Zone (ALZ) scaffold for tenants that
need an ITAR-aligned workload boundary alongside a non-ITAR boundary, deployed
entirely in **Azure Commercial** cloud. Inspired by
[Azure Landing Zones (Terraform)][alz], [AzureNoOps][noops], and
[MissionLZ][mlz], but intentionally minimal: the management group hierarchy,
opinionated baseline policies, and module stubs for each platform subscription —
nothing more until you ask for it.

[alz]: https://azure.github.io/Azure-Landing-Zones/terraform/
[noops]: https://github.com/azurenoops/
[mlz]: https://github.com/Azure/missionlz

## Architecture

```
tenant root
└── <prefix>-root
    ├── platform                          ── contains the platform subscriptions:
    │                                          • identity      (Managed HSM, …)
    │                                          • management    (Log Analytics, Sentinel, Defender, …)
    │                                          • connectivity  (hub VNet, Firewall, DNS, Bastion)
    └── landingzones
        ├── itar          ── ITAR workload subscriptions
        │                    • US commercial allowed locations
        │                    • CMK-encrypted storage
        │                    • Tagging + private-endpoint baselines
        └── non-itar      ── non-ITAR workload subscriptions
                             • US commercial allowed locations
                             • Tagging + private-endpoint baselines
```

Subscriptions are created out-of-band (EA / MCA / manual) and their IDs are
passed in via `subscriptions = { … }` in your `*.tfvars`. Terraform places
them under the correct management group and applies the baselines.

## Repository layout

```
environments/
  example.tfvars            # template — copy to creds.tfvars and fill in
  creds.tfvars              # gitignored; real credentials + config live here
policies/                   # custom policy JSON (built-ins are referenced inline today)
terraform/
  providers.tf              # azurerm + per-platform-subscription aliases
  variables.tf              # all root inputs
  locals.tf                 # naming, MG IDs, common tags
  main.tf                   # module wiring
  outputs.tf
  modules/
    management-groups/      # 3-tier MG hierarchy + subscription placement
    policies/               # opinionated baseline assignments (built-ins)
    platform-identity/      # SCAFFOLD — Managed HSM, identity services
    platform-management/    # SCAFFOLD — Log Analytics + Sentinel + Defender
    platform-connectivity/  # SCAFFOLD — hub VNet, Firewall, Bastion, DNS
```

The three `platform-*` modules currently create only a resource group (and a
Log Analytics workspace, in the management module) plus inline `# TODO:`
markers for the remaining services. Build them out as you onboard each
platform subscription.

## Prerequisites

- Terraform `>= 1.15`
- A service principal with the following at the **tenant root** scope:
  - `Management Group Contributor`
  - `Resource Policy Contributor`
  - `Owner` on each subscription you intend to manage
- The subscription IDs you want to place under each leaf MG

## Getting started

```bash
cp environments/example.tfvars environments/creds.tfvars
# edit environments/creds.tfvars with your SP credentials, prefix,
# subscription IDs, and any policy overrides

cd terraform
terraform init
terraform plan  -var-file=../environments/creds.tfvars
terraform apply -var-file=../environments/creds.tfvars
```

On the first run with empty `subscriptions` you get the management group
hierarchy and the policy assignments. As subscriptions become available,
add their IDs and flip the matching `deploy_*` flag to roll the platform
baselines out one subscription at a time.

## Opinionated defaults applied today

| Scope        | Policy                                                           |
| ------------ | ---------------------------------------------------------------- |
| Root MG      | Require `workload` tag on resource groups                        |
| ITAR MG      | Allowed resource locations (US commercial only)                  |
| ITAR MG      | Allowed resource group locations (US commercial only)            |
| ITAR MG      | Storage accounts must use customer-managed keys                  |
| Non-ITAR MG  | Allowed resource locations (US commercial)                       |
| Non-ITAR MG  | Allowed resource group locations (US commercial)                 |

Region lists, tag keys, and feature flags are all overridable in your
`*.tfvars` — see [environments/example.tfvars](environments/example.tfvars).

## Security notes

- `environments/creds.tfvars` is git-ignored (`*.tfvars` blanket rule). Never
  commit a real client secret. If a secret is ever committed, rotate it in
  Entra ID immediately.
- Use a remote state backend (Azure Storage with `prevent_destroy` and
  customer-managed keys) before promoting this scaffold beyond a sandbox.
- Service principal least privilege: scope the SP to the tenant root only
  for the initial bootstrap; narrow afterward.
