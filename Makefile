.PHONY: almalinux9 ubuntu2404 almalinux8 ubuntu2204 all

all: almalinux9 ubuntu2404 almalinux8 ubuntu2204

almalinux9:
	packer init almalinux9/almalinux-9-x86_64.pkr.hcl
	packer build -var-file variables.pkrvars.hcl almalinux9/almalinux-9-x86_64.pkr.hcl

ubuntu2404:
	packer init ubuntu2404/ubuntu-24.04.pkr.hcl
	packer build -var-file variables.pkrvars.hcl ubuntu2404/ubuntu-24.04.pkr.hcl

ubuntu2204:
	packer init ubuntu2204/ubuntu-22.04.pkr.hcl
	packer build -var-file variables.pkrvars.hcl ubuntu2204/ubuntu-22.04.pkr.hcl

almalinux8:
	packer init almalinux8/almalinux-8-x86_64.pkr.hcl
	packer build -var-file variables.pkrvars.hcl almalinux8/almalinux-8-x86_64.pkr.hcl