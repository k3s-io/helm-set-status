package status

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/k3s-io/helm-set-status/pkg/common"
	"github.com/pkg/errors"
	"helm.sh/helm/v3/pkg/action"
	"helm.sh/helm/v3/pkg/release"
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
	latestRelease.Info.LastDeployed.Time = time.Now().UTC()

	if err := recordRelease(latestRelease, cfg); err != nil {
		return errors.Wrapf(err, "failed to update release %s", options.ReleaseName)
	}
	log.Printf("release %s status updated", options.ReleaseName)
	return nil
}

func getLatestRelease(releaseName string, cfg *action.Configuration) (*release.Release, error) {
	return cfg.Releases.Last(releaseName)
}

func recordRelease(r *release.Release, cfg *action.Configuration) error {
	return cfg.Releases.Update(r)
}
