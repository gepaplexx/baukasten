liveness: {
	alias: ""
	annotations: {}
	attributes: {
		appliesToWorkloads: ["deployment"]
		conflictsWith: []
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: "A trait to apply a livenessprobe to a deployment"
	labels: {}
	type: "trait"
}

template: {
	patch: {
		spec: template: spec: {
			// +patchKey=name
			containers: [{
				name: context.name
				livenessProbe:
					httpGet: {
						path: parameter.path
						port: parameter.port
						scheme: parameter.scheme
					}
			}]
		}
	}
	parameter: {
		path: string
		port: *8080 | int
		scheme: *"HTTP" | string
	}
}

