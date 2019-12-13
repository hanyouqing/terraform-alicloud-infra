# terraform-alicloud-infra

Alicloud Infrasture Management With Terraform.

* Terraform Workflow

```
Engineer  
-> terraform 
  -> terraform-alicloud-plugin 
    -> alicloud api 
      -> create/change/destory resources 
        -> save state 
          -> upload to oss
```

## Install tfenv

> `tfenv` for terraform is just like nvm for nodejs or pyenv for python.

```
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
cd ~/.tfenv && git checkout $(git tag |grep -v alpha|tail -1)
git -

grep '.tfenv' ~/.bash_profile || echo 'export PATH=\$HOME/.tfenv:\$PATH' >> ~/.bash_profile

source ~/.bash_profile

tfenv list-remote
tfenv install latest && tfenv use latest
tfenv list
which terraform && terraform --version
```

## Quick Start

```
git clone https://github.com/icmdb/terraform-alicloud-infra.git

cd terraform-alicloud-infra

cp tfenvars.sh.example tfenvars.sh

vi tfenvars.sh  # setting up your access key and secret

. ./tfenvars.sh

terraform workspace new cn-beijing
terraform workspace list

terraform init
terraform plan
terraform apply
terraform output
terraform graph
```

## Questions

1. variables not supported by backend, see backend in [main.tf](main.tf)
2. backend oss bucket autocreate is expected.
3. datasources can not be output very well, for example: regions in [datasource.tf](datasource.tf) 

## Useful datasources

> You may get some useful information [datasource here](./tf-jsondata/).


## Reference

* [Backend Configuration - terraform.io](https://www.terraform.io/docs/backends/config.html)
  * [Remote Backend - terraform.io](https://www.terraform.io/docs/backends/types/remote.html)
  * [OSS Backend - terraform.io](https://www.terraform.io/docs/backends/types/oss.html)
* [CLI Configuration File - terraform.io](https://www.terraform.io/docs/commands/cli-config.html)
* [Environment Variables - terraform.io](https://www.terraform.io/docs/commands/environment-variables.html)
* [Data Sources - terraform.io](https://www.terraform.io/docs/configuration/data-sources.html)
* Functions
  * [lookup](https://www.terraform.io/docs/configuration/functions/lookup.html)
  * [join](https://www.terraform.io/docs/configuration/functions/join.html) 
  * [format](https://www.terraform.io/docs/configuration/functions/format.html)
* [Publishing Modules - terraform.io](https://www.terraform.io/docs/registry/modules/publish.html)
* [Providers - terraform.io](https://www.terraform.io/docs/providers/index.html)
  * [Alibaba Cloud Provider - terraform.io](https://www.terraform.io/docs/providers/alicloud/index.html)
* [Command: console - terraform.io](https://www.terraform.io/docs/commands/console.html)
* [Debugging Terraform - terraform.io](https://www.terraform.io/docs/internals/debugging.html)
