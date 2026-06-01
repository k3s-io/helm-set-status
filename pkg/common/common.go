package common

import (
	release "helm.sh/helm/v4/pkg/release/common"
)

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
