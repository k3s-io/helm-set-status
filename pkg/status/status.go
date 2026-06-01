package status

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/k3s-io/helm-set-status/pkg/common"
	"github.com/pkg/errors"
	"helm.sh/helm/v4/pkg/action"
	"helm.sh/helm/v4/pkg/release"
	releasev1 "helm.sh/helm/v4/pkg/release/v1"
)

func SetStatus(options common.RunOptions) error {
	cfg, err := GetActionConfig(options.ReleaseNamespace, options.KubeConfig)
	if err != nil {
		return errors.Wrap(err, "failed to get Helm action configuration")
	}

	var releaseName = options.ReleaseName

	latestRelease, err := getLatestRelease(releaseName, cfg)
	if err != nil {
		return errors.Wrapf(err, "failed to get release %s", options.ReleaseName)
	}
	latestRelease.SetStatus(options.ReleaseStatus, fmt.Sprintf("status forced by %s", os.Args[0]))
	latestRelease.Info.LastDeployed = time.Now().UTC()

	if err := recordRelease(latestRelease, cfg); err != nil {
		return errors.Wrapf(err, "failed to update release %s", options.ReleaseName)
	}
	log.Printf("release %s status updated", options.ReleaseName)
	return nil
}

func getLatestRelease(releaseName string, cfg *action.Configuration) (*releasev1.Release, error) {
	r, err := cfg.Releases.Last(releaseName)
	if err != nil {
		return nil, err
	}
	return releaserToV1Release(r)
}

func recordRelease(r *releasev1.Release, cfg *action.Configuration) error {
	return cfg.Releases.Update(r)
}

func releaserToV1Release(rel release.Releaser) (*releasev1.Release, error) {
	switch r := rel.(type) {
	case releasev1.Release:
		return &r, nil
	case *releasev1.Release:
		return r, nil
	case nil:
		return nil, nil
	default:
		return nil, fmt.Errorf("unsupported release type: %T", rel)
	}
}
