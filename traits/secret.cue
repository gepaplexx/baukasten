secret: {
	alias: ""
	annotations: {}
	attributes: {
		appliesToWorkloads: ["deployment"]
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
		"\(parameter.name)": {
			apiVersion: "v1"
			kind: "Secret"
			metadata: {
				name: parameter.name
			}
			data: parameter.data
		}
	}
	patch: {
		if parameter.mountPath != _|_ {
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
	}
	parameter: {
		name: string
		mountPath?: string // if empty => create secret only
		data: [string]: string
	}
}

