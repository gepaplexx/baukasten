basicapp: {
	alias: ""
	annotations: {
		"definitionrevision.oam.dev/name": "2.0"
	}
	attributes: workload: definition: {
		apiVersion: "apps/v1"
		kind:       "Deployment"
	}
	description: "basic app component"
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			labels: app: context.name
			name: context.name + "-deployment"
		}
		spec: {
			replicas: parameter.replicas
			selector: matchLabels: app: context.name
			template: {
				metadata: labels: app: context.name
				spec: containers: [{
					image: parameter.image
					name:  context.name
				}]
			}
		}
	}
	outputs: "service": {
		apiVersion: "v1"
		kind:       "Service"
		metadata: name: context.name + "-service"
		spec: {
			ports: [{
				port:       parameter.port
				protocol:   "TCP"
				targetPort: parameter.targetPort
			}]
			selector: app: context.name
			type: "ClusterIP"
		}
	}
	parameter: {
		image: string
		replicas: number
		port: number
		targetPort: number
	}
}
