package status

import (
	"fmt"
	"log"
	"os"

	"github.com/brandond/helm-set-status/pkg/common"
	"helm.sh/helm/v3/pkg/action"
	"helm.sh/helm/v3/pkg/cli"
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

	err := actionConfig.Init(settings.RESTClientGetter(), namespace, os.Getenv("HELM_DRIVER"), debug)
	if err != nil {
		return nil, err
	}

	return actionConfig, err
}

func debug(format string, v ...interface{}) {
	if settings.Debug {
		format = fmt.Sprintf("[debug] %s\n", format)
		_ = log.Output(callDepth, fmt.Sprintf(format, v...))
	}
}
