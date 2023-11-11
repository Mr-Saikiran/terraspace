# terraspace

SAST tools testing on terraform with **TFlint** **TFSec** **Checkov** **terratest**

#### provider config

```hcl
provider "aws" { 
  region                   = "eu-west-2" 
  shared_credentials_files = ["~/.aws/credentials"] 
  profile                  = "terraform" 
} 
```

#### sample terratest

```go
package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformHelloWorldExample(t *testing.T) {
	// website::tag::2:: Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
	//	TerraformDir: "../examples/terraform-hello-world-example",
      TerraformDir: "./"
	})

	// website::tag::5:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::3:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::4:: Run `terraform output` to get the values of output variables and check they have the expected values.
	output := terraform.Output(t, terraformOptions, "hello_world")
	assert.Equal(t, "Hello, World!", output)
}
```



## TFSec

```bash
tfsec .
```

## TFlint

tested through GHA (workflow](https://github.com/terraform-linters/setup-tflint)

also tested with tflint

```bash
tflint --chdir=/terraspace/ -c /terraspace/.tflint.hcl -f default 

## Checkov

```bash
checkov --directory /terraspace/
checkov --file /terraspace/main.tf
```

Or a terraform plan file in json format

```bash
terraform init
terraform plan -out tf.plan
terraform show -json tf.plan  > tf.json 
checkov -f tf.json
```
