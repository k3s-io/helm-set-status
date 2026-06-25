BINARY := helm-set-status

HELM_PLUGIN := $(shell helm env | sed -n -e 's/HELM_PLUGINS=[ "]*\([^"]*\).*/\1/p')
HELM_PLUGIN_PATH ?= $(HELM_PLUGIN)/$(BINARY)

VERSION := $(shell sed -n -e 's/version:[ "]*\([^"]*\).*/\1/p' plugin.yaml)
LDFLAGS := "-w -s"
TAGS := "netgo osusergo"
OS_PLATFORM := $(shell uname -sp | tr '[:upper:] ' '[:lower:]-' | sed 's/x86_64/amd64/')

.PHONY: install
install: build
	[ -e $(HELM_PLUGIN_PATH) ] || mkdir -p $(HELM_PLUGIN_PATH)
	cp bin/$(BINARY) $(HELM_PLUGIN_PATH)/
	cp plugin.yaml $(HELM_PLUGIN_PATH)/

.PHONY: package
package: build
	[ -e dist ] || mkdir -p dist
	tar -czvf dist/$(BINARY)-$(OS_PLATFORM).tgz -C bin/ helm-set-status

.PHONY: build
build:
	go build -o bin/$(BINARY) -tags $(TAGS) -ldflags $(LDFLAGS) ./cmd/helm-set-status

.PHONY: lint
lint:
	golangci-lint run -v ./pkg/... ./cmd/...

.PHONY: test
test:
	go test -v ./cmd/... ./pkg/...
