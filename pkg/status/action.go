package status

import (
	"os"

	"github.com/k3s-io/helm-set-status/pkg/common"
	"helm.sh/helm/v4/pkg/action"
	"helm.sh/helm/v4/pkg/cli"
)

const (
	callDepth = 2
)

var (
	settings = cli.New()
)

func GetActionConfig(namespace string, kubeConfig common.KubeConfig) (*action.Configuration, error) {
	actionConfig := new(action.Configuration)

	settings.KubeConfig = kubeConfig.File
	settings.KubeContext = kubeConfig.Context

	if namespace == "" {
		namespace = settings.Namespace()
	}

	err := actionConfig.Init(settings.RESTClientGetter(), namespace, os.Getenv("HELM_DRIVER"))
	if err != nil {
		return nil, err
	}

	return actionConfig, err
}
