package common

import "helm.sh/helm/v3/pkg/release"

type HelmOptions struct {
	ReleaseName      string
	ReleaseNamespace string
	ReleaseStatus    release.Status
}

type KubeConfig struct {
	Context string
	File    string
}

type RunOptions struct {
	KubeConfig       KubeConfig
	ReleaseName      string
	ReleaseNamespace string
	ReleaseStatus    release.Status
}
