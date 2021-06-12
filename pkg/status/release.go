package status

import (
	"fmt"

	"helm.sh/helm/v3/pkg/release"
)

func ReleaseStatus(s string) (release.Status, error) {
	switch s {
	case string(release.StatusUnknown):
		return release.StatusUnknown, nil
	case string(release.StatusDeployed):
		return release.StatusDeployed, nil
	case string(release.StatusSuperseded):
		return release.StatusSuperseded, nil
	case string(release.StatusFailed):
		return release.StatusFailed, nil
	case string(release.StatusUninstalling):
		return release.StatusUninstalling, nil
	case string(release.StatusPendingInstall):
		return release.StatusPendingInstall, nil
	case string(release.StatusPendingUpgrade):
		return release.StatusPendingUpgrade, nil
	case string(release.StatusPendingRollback):
		return release.StatusPendingRollback, nil
	}

	return release.StatusUnknown, fmt.Errorf("invalid release status %s", s)
}
