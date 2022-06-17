# PIP Shared Infrastructure

[![Build Status](https://travis-ci.org/hmcts/pip-shared-infrastructures.svg?branch=master)](https://travis-ci.org/hmcts/pip-shared-infrastructures)

## Purpose

The purpose of this repository is to build the shared infrastructure for the application Publication and Information.

## Supporting Reponsitories

The repository `pip-shared-infrastructure-bootstap` contains infrastructure that supports this pipeline to provide a source for secure variables used within the pipeline.

## Setup APIM Key Vault Access

To give a clients Managed Identity access to the APIM Key Vault, you will need get the Managed Identity Client ID.
This can then be added to the Variable `apim_kv_mi_access` in the respective environments `tfvars`.


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
