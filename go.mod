module github.com/k3s-io/helm-set-status

go 1.16

// pin this version to address a vulnerability
// updating to helm v3.6.3 did not cause this transitive dependency to update to a fixed version
replace github.com/opencontainers/runc => github.com/opencontainers/runc v1.0.0

require (
	github.com/pkg/errors v0.9.1
	github.com/spf13/cobra v1.1.3
	github.com/spf13/pflag v1.0.5
	helm.sh/helm/v3 v3.6.3
	rsc.io/letsencrypt v0.0.3 // indirect
)
