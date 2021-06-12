BINARY := helm-set-status

HELM_PLUGIN := $(shell helm env|sed -n -e 's/HELM_PLUGINS=[ "]*\([^"]*\).*/\1/p')
HELM_PLUGIN_PATH ?= $(HELM_PLUGIN)/$(BINARY)

VERSION := $(shell sed -n -e 's/version:[ "]*\([^"]*\).*/\1/p' plugin.yaml)
LDFLAGS := "-X main.version=${VERSION} -extldflags -static -w -s"
TAGS := "static_build netcgo osusergo"

GO111MODULE = on
CGO_ENABLED = 1

.PHONY: install
install: build
	[ -e $(HELM_PLUGIN_PATH) ] || mkdir -p $(HELM_PLUGIN_PATH)
	cp bin/$(BINARY) $(HELM_PLUGIN_PATH)/
	cp plugin.yaml $(HELM_PLUGIN_PATH)/

.PHONY: build
build:
	go build -o bin/$(BINARY) -tags $(TAGS) -ldflags $(LDFLAGS) ./cmd/helm-set-status
