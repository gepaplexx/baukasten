secret: {
	alias: ""
	annotations: {}
	attributes: {
		appliesToWorkloads: ["backend"]
		conflictsWith: []
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: "A trait to create and mount a secret."
	labels: {}
	type: "trait"
}

template: {
	outputs: {
		"secret": {
			apiVersion: "v1"
			kind: "Secret"
			metadata: {
				name: parameter.name
			}
			data: parameter.data
		}
	}
	patch: {
		spec: template: spec: {
			// +patchKey=name
      containers: [{
      	name: context.name
				volumeMounts: [{
					name: "secret-" + parameter.name
					mountPath: parameter.mountPath
				}]
			}]

			volumes: [{
				name: "secret-" + parameter.name
				secret: {
					secretName: parameter.name
				}
			}]
		}
	}
	parameter: {
		name: string
		mountPath: string
		data: [string]: string
	}
}

