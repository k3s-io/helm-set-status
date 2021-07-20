module github.com/k3s-io/helm-set-status

go 1.16

replace (
	// pin these versions to address vulnerabilities
	// updating to helm v3.6.3 did not cause these transitive dependencies to update to a fixed version
	github.com/docker/distribution => github.com/docker/distribution v2.7.0-rc.0+incompatible
	github.com/opencontainers/runc => github.com/opencontainers/runc v1.0.0-rc9.0.20200122160610-2fc03cc11c77
)

require (
	github.com/bshuster-repo/logrus-logstash-hook v1.0.2 // indirect
	github.com/bugsnag/bugsnag-go v2.1.1+incompatible // indirect
	github.com/bugsnag/panicwrap v1.3.3 // indirect
	github.com/docker/go-metrics v0.0.1 // indirect
	github.com/docker/libtrust v0.0.0-20160708172513-aabc10ec26b7 // indirect
	github.com/garyburd/redigo v1.6.2 // indirect
	github.com/gofrs/uuid v4.0.0+incompatible // indirect
	github.com/gorilla/handlers v1.5.1 // indirect
	github.com/kardianos/osext v0.0.0-20190222173326-2bc1f35cddc0 // indirect
	github.com/pkg/errors v0.9.1
	github.com/spf13/cobra v1.1.3
	github.com/spf13/pflag v1.0.5
	github.com/yvasiyarov/go-metrics v0.0.0-20150112132944-c25f46c4b940 // indirect
	github.com/yvasiyarov/gorelic v0.0.7 // indirect
	github.com/yvasiyarov/newrelic_platform_go v0.0.0-20160601141957-9c099fbc30e9 // indirect
	helm.sh/helm/v3 v3.6.3
	rsc.io/letsencrypt v0.0.3 // indirect
)
