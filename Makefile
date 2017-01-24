platform := $(shell uname)

install: install-third-party-tools

ifeq (${platform},Darwin)
install-third-party-tools:
	brew install packer terraform nodejs
	npm install -g yaml-cli
else
install-third-party-tools:
	@echo "${platform} is a platform we have no presets for, you'll have to install the third party dependencies manually (packer, terraform, nodejs, yaml-cli (via npm)"
endif

validate-trusty:
	@yaml json write packer/base/trusty.yml | packer validate -

build-trusty: validate-trusty
	@yaml json write packer/base/trusty.yml | packer build -
	
validate-consul-server:
	@yaml json write packer/consul-server/trusty.yml | packer validate -

build-consul-server: validate-consul-server
	@yaml json write packer/consul-server/trusty.yml | packer build -var="registry_bucket=${BUCKET}" -var="region=${AWS_REGION}" -

.PHONY: install-third-party-tools build-trusty validate-trusty build-consul-server validate-consul-server 
