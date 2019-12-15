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

## Pre-depends

### Install tfenv

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

### AliCloud

* Create OSS bucket named `terraform-alicloud-infra`, see: [main.tf](main.tf)
* Create AccessKey


## Quick Start

```
git clone https://github.com/icmdb/terraform-alicloud-infra.git

cd terraform-alicloud-infra/examples/demo/

cp tfenvars.sh.example tfenvars.sh

vi tfenvars.sh  # setting up your access key and secret

. ./tfenvars.sh

terraform workspace new cn-beijing
terraform workspace list

terraform init
terraform plan
terraform apply
```

## Questions

* variables not supported by backend, see backend in [main.tf](main.tf)
* backend oss bucket autocreate is expected.
* datasources can not be output very well, for example: regions in [datasource.tf](datasource.tf) 
* is locals supported by module
