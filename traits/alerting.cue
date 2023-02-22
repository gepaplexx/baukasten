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
		// +usage=List of alerting rules
		rules: [...{
			// +usage=Alert name
			name: string
			// +usage=Description of the alert
			summary: string
			// +usage=PromQL Expression
			expr: string
			// +usage=Polling interval
			interval: *"30s" | string
			// +usage=Fire this alert, if the condition is satisfied for this amount of time
			for: string
			// +usage=Severity of the alert
			severity: "critical" | "warning" | "info" | "none"
		}]
	}
}

