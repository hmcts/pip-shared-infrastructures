# PIP Shared Infrastructure

## Table of Contents

- [Overview](#overview)
- [Supporting Repositories](#supporting-repositories)
- [Setup APIM Key Vault Access](#setup-apim-key-vault-access)
- [License](#license)

## Overview

The purpose of this repository is to build the shared infrastructure for the application Publication and Information.

## Supporting Repositories

The repository `pip-shared-infrastructure-bootstap` contains infrastructure that supports this pipeline to provide a source for secure variables used within the pipeline.

## Setup APIM Key Vault Access

To give a clients Managed Identity access to the APIM Key Vault, you will need get the Managed Identity Client ID.
This can then be added to the Variable `apim_kv_mi_access` in the respective environments `tfvars`.

## Federated Identity Setup

The federated identity setup for the MI is configured via the bootstrap KV value named 'crime-oidc-issuer-config'. This is a JSON object that contains the following properties:

```json
{
  "connections": [
    {
      "name": "unique name goes here",
      "issuer": "issuer goes here",
      "subject": "subject goes here"
    }
  ]
}
```

New federated identities should be added into the connections array and uploaded to the KV. You will need a copy of the current value first. The pipeline can then be re-run which will apply these.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
