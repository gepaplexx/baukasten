import (
	"strconv"
)

"service-monitor": {
	alias: ""
	annotations: {}
	attributes: {
		appliesToWorkloads: ["deployment"]
		conflictsWith: []
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: "A trait to add a ServiceMonitor to a deployment"
	labels: {}
	type: "trait"
}

template: {
	outputs: {
		"service-monitor": {
			apiVersion: "monitoring.coreos.com/v1"
			kind:       "ServiceMonitor"
			metadata: {
				name:      "scraping-" + context.name
			}
			spec: {
				endpoints: [{
					interval: parameter.interval
					path:     parameter.path
					port:     "port-" + strconv.FormatInt(parameter.port, 10)
					scheme:   parameter.scheme
				}]
				selector: matchLabels: "app.oam.dev/component": context.name
			}
		}
	}
	parameter: {
		interval: *"30s" | string
		path: string
		port: *8080 | int
		scheme: *"http" | string
	}
}

