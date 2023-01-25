import (
	"strconv"
)

"alerting": {
	alias: ""
	annotations: {}
	attributes: {
		appliesToWorkloads: ["deployment"]
		conflictsWith: []
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: "A trait to add alerts to a deployment"
	labels: {}
	type: "trait"
}

template: {
	outputs: {
		if len(parameter.rules) > 0 {
			"prometheus-rule": {
				apiVersion: "monitoring.coreos.com/v1"
				kind:       "PrometheusRule"
				metadata:
					name: "alerts-" + context.name
				spec: groups: [for r in parameter.rules {
					interval: r.interval
					name:     r.name
					rules: [{
						alert: "alert-" + context.name + "-" + r.name
						annotations: summary: r.summary
						expr: r.expr
						for:  r["for"]
						labels:
							severity: r.severity
					}]
				}]
			}
		}
	}
	parameter: {
		rules: [...{
			name: string
			summary: string
			expr: string
			interval: *"30s" | string
			for: string
			severity: "critical" | "warning" | "info" | "none"
		}]
	}
}

