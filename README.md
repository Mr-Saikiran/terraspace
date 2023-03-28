# terraform

```hcl
provider "aws" { 

  region                   = "eu-west-2" 

  shared_credentials_files = ["~/.aws/credentials"] 

  profile                  = "terraform" 

} 
```
