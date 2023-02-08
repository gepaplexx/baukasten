"db-connector-es": {
	alias: ""
	annotations: {}
	attributes: {
		appliesToWorkloads: ["deployment"]
		conflictsWith: []
		podDisruptive:   false
		workloadRefPath: ""
	}
	description: "A trait to connect a backend to a db (for external secrets version)."
	labels: {}
	type: "trait"
}

// TODO momentan nur für postgresql
template: {
	outputs: serviceBinding: {
		apiVersion: "binding.operators.coreos.com/v1alpha1"
		kind:       "ServiceBinding"
		metadata: {
			name:      context.name + "-db-binding"
		}
		spec: {
			bindAsFiles: false
			namingStrategy: "none"
			application: {
				name:     context.name
				group:    "apps"
				resource: "deployments"
				version:  "v1"
			}
			services: [{
				name:    parameter.connectTo + "-connector"
				group:   ""
				version: "v1"
				id:      "connectorSecret"
				kind:    "Secret"
			}]
			mappings: [{
				name: "DB_USER"
				value: "{{ index . \"username\"}}"
			}, {
				name: "DB_PASSWORD"
				value: "{{ index . \"user-password\" }}"
			}, {
				name: "DB_JDBC_URL"
				value: "{{ index . \"jdbcUrl\" }}"
			}]
		}
	}
	patch: {}
	parameter: {
		connectTo: string
	}
}