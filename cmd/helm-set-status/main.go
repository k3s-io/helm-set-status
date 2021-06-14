package main

import (
	"errors"
	"io"
	"os"

	"github.com/k3s-io/helm-set-status/pkg/common"
	"github.com/k3s-io/helm-set-status/pkg/status"
	"github.com/spf13/cobra"
)

var (
	settings *EnvSettings
)

func NewRootCmd(out io.Writer, args []string) *cobra.Command {
	cmd := &cobra.Command{
		Use:          "helm set-status RELEASE STATUS [flags]",
		SilenceUsage: true,
		Args: func(cmd *cobra.Command, args []string) error {
			if len(args) == 0 {
				cmd.Help()
				os.Exit(1)
			} else if len(args) != 2 {
				return errors.New("release and status must be specified")
			}
			return nil
		},
		RunE: runSetStatus,
	}
	flags := cmd.PersistentFlags()
	flags.Parse(args)
	settings = new(EnvSettings)
	settings.AddFlags(flags)

	return cmd
}

func runSetStatus(cmd *cobra.Command, args []string) error {
	releaseName := args[0]
	releaseStatus, err := status.ReleaseStatus(args[1])
	if err != nil {
		return err
	}

	helmOptions := common.HelmOptions{
		ReleaseName:      releaseName,
		ReleaseNamespace: settings.Namespace,
		ReleaseStatus:    releaseStatus,
	}
	kubeConfig := common.KubeConfig{
		Context: settings.KubeContext,
		File:    settings.KubeConfig,
	}
	return SetStatus(helmOptions, kubeConfig)
}

func SetStatus(helmOptions common.HelmOptions, kubeConfig common.KubeConfig) error {
	options := common.RunOptions{
		KubeConfig:       kubeConfig,
		ReleaseName:      helmOptions.ReleaseName,
		ReleaseNamespace: helmOptions.ReleaseNamespace,
		ReleaseStatus:    helmOptions.ReleaseStatus,
	}
	return status.SetStatus(options)
}

func main() {
	setStatusCmd := NewRootCmd(os.Stdout, os.Args[1:])

	if err := setStatusCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
