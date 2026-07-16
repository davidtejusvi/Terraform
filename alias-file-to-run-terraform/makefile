.PHONY: i p a d fmt val opt show refresh state clean

i:
	terraform init

fmt:
	terraform fmt -recursive

val:
	terraform validate

p:
	terraform plan

a:
	terraform apply --auto-approve

d:
	terraform destroy --auto-approve

opt:
	terraform output

show:
	terraform show

refresh:
	terraform refresh

state:
	terraform state list

clean:
	rm -rf .terraform
	rm -f .terraform.lock.hcl

// use case
make i         ->    terraform init
make fmt       ->    terraform format
make val       ->    terraform validate
make p         ->    terraform plan
make a         ->    terraform apply --auto--approve
make opt       ->    terraform output
make d         ->    terraform destroy --auto-approve
