"loki-alerting": {
	alias: ""
	annotations: {}
	attributes: {
		appliesToWorkloads: ["deployment"]
		conflictsWith: []
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: "A trait to add Loki alerting to a deployment"
	labels: {}
	type: "trait"
}

template: {
	outputs: {
	  "loki-alerting": {
  		apiVersion: "loki.grafana.com/v1beta1"
  		kind:       "AlertingRule"
  		metadata: name: "loki-alerting-" + context.name
  		spec: {
  			groups: parameter.groups
  			tenantID: "application"
  		}
  	}
  }
	parameter: {
		groups: [...{
			interval: string
			limit: number
			name: string
			rules: [...{
				alert: string
				expr: string
				for: string
			}]
		}]
	}
}

