HELM_HOME ?= $(shell helm home)
BINARY := helm-set-status
VERSION := $(shell sed -n -e 's/version:[ "]*\([^"]*\).*/\1/p' plugin.yaml)

HELM_3_PLUGINS := $(shell helm env HELM_PLUGINS)
LDFLAGS := -X main.version=${VERSION}

GO ?= go

.PHONY: format
format:
	test -z "$$(find . -type f -o -name '*.go' -exec gofmt -d {} + | tee /dev/stderr)" || \
	test -z "$$(find . -type f -o -name '*.go' -exec gofmt -w {} + | tee /dev/stderr)"

.PHONY: install
install: build
	mkdir -p $(HELM_3_PLUGINS)/helm-set-status/bin
	cp bin/$(BINARY) $(HELM_3_PLUGINS)/helm-set-status/bin
	cp plugin.yaml $(HELM_3_PLUGINS)/helm-set-status/

.PHONY: lint
lint:
	scripts/update-gofmt.sh
	scripts/verify-gofmt.sh
	scripts/verify-govet.sh
	scripts/verify-staticcheck.sh

.PHONY: build
build: lint
	mkdir -p bin/
	go build -v -o bin/$(BINARY) -ldflags="$(LDFLAGS)" ./cmd/helm-set-status

.PHONY: test
test:
	go test -v ./... -coverprofile cover.out -race
	go tool cover -func cover.out

.PHONY: bootstrap
bootstrap:
	go mod download
	command -v staticcheck || go install honnef.co/go/tools/cmd/staticcheck@latest

.PHONY: dist
dist: export COPYFILE_DISABLE=1 #teach OSX tar to not put ._* files in tar archive
dist: export CGO_ENABLED=0
dist:
	rm -rf build/$(BINARY)/* release/*
	mkdir -p build/$(BINARY)/bin release/
	cp README.md LICENSE plugin.yaml build/$(BINARY)
	GOOS=linux GOARCH=amd64 $(GO) build -o build/$(BINARY)/bin/$(BINARY) -trimpath -ldflags="$(LDFLAGS)" ./cmd/helm-set-status
	tar -C build/ -zcvf $(CURDIR)/release/helm-set-status-linux-amd64.tgz $(BINARY)/
	GOOS=linux GOARCH=arm64 $(GO) build -o build/$(BINARY)/bin/$(BINARY) -trimpath -ldflags="$(LDFLAGS)" ./cmd/helm-set-status
	tar -C build/ -zcvf $(CURDIR)/release/helm-set-status-linux-arm64.tgz $(BINARY)/
	GOOS=freebsd GOARCH=amd64 $(GO) build -o build/$(BINARY)/bin/$(BINARY) -trimpath -ldflags="$(LDFLAGS)" ./cmd/helm-set-status
	tar -C build/ -zcvf $(CURDIR)/release/helm-set-status-freebsd-amd64.tgz $(BINARY)/
	GOOS=darwin GOARCH=amd64 $(GO) build -o build/$(BINARY)/bin/$(BINARY) -trimpath -ldflags="$(LDFLAGS)" ./cmd/helm-set-status
	tar -C build/ -zcvf $(CURDIR)/release/helm-set-status-macos-amd64.tgz $(BINARY)/
	GOOS=darwin GOARCH=arm64 $(GO) build -o build/$(BINARY)/bin/$(BINARY) -trimpath -ldflags="$(LDFLAGS)" ./cmd/helm-set-status
	tar -C build/ -zcvf $(CURDIR)/release/helm-set-status-macos-arm64.tgz $(BINARY)/
	rm build/$(BINARY)/bin/$(BINARY)
	GOOS=windows GOARCH=amd64 $(GO) build -o build/$(BINARY)/bin/$(BINARY).exe -trimpath -ldflags="$(LDFLAGS)" ./cmd/helm-set-status
	tar -C build/ -zcvf $(CURDIR)/release/helm-set-status-windows-amd64.tgz $(BINARY)/
	rm -rf build/

# Manual release process - CI uses goreleaser to do multiarch compilation and release
.PHONY: release
release: lint dist
	scripts/release.sh v$(VERSION)

# Test for the plugin installation with `helm plugin install -v THIS_BRANCH` works
# Useful for verifying modified `install-binary.sh` still works against various environments
.PHONY: test-plugin-installation
test-plugin-installation:
	docker build -f testdata/Dockerfile.install .
