SHELL = /usr/bin/env bash -euo pipefail

# If you pass 'only=<builder>', it will get sent to the '-only=' flag for
# 'packer build'
ifdef only
onlyflag = -only=$(only)
endif

validate:
	shellcheck scripts/*.sh
	packer validate \
		-var node_type="$${node_type}" \
		-var platform="$${platform}" \
		-var-file vars.json \
		packer.json

build: validate
	packer build \
		-var-file vars.json \
		-var node_type="$${node_type}" \
		-var platform="$${platform}" \
		-force \
		$(onlyflag) \
		-- \
		packer.json
