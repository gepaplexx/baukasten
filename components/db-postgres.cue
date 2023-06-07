import "encoding/base64"

"db-postgres": {
	alias: ""
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "argoproj.io/v1alpha1"
		kind:       "Application"
	}
	description: "A component to deploy a Postgres Database with ArgoCD."
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "argoproj.io/v1alpha1"
		kind:       "Application"
		metadata: name: context.name
		spec: {
			destination: {
				namespace: context.namespace
				server:    "https://kubernetes.default.svc"
			}
			project: "default" // TODO
			source: {
				chart: "postgresql"
				helm: parameters: [{
					name:  "primary.containerSecurityContext.enabled"
					value: "false"
				}, {
					name:  "primary.podSecurityContext.enabled"
					value: "false"
				}, {
					name: "auth.username"
					value: parameter.user
				}, {
					name: "auth.database"
					value: parameter.database
				}]
				repoURL:        "https://charts.bitnami.com/bitnami"
				targetRevision: "11.0.3" // TODO
			}
			syncPolicy: {
				automated: {
					prune:    true
					selfHeal: true
				}
				syncOptions: ["CreateNamespace=true"]
			}
		}
	}
	outputs: {
		blubb: {
			apiVersion: "v1"
			kind: "Secret"
			type: "Opaque"
			metadata: {
				name: context.name + "-connector"
			}
			data: {
				database: base64.Encode(null, parameter.database)
				username: base64.Encode(null, parameter.user)
				jdbcUrl: base64.Encode(null, "jdbc:postgresql://" + context.name + "-postgresql." + context.namespace + ".svc.cluster.local/" + parameter.database)
			}
		}
	}
	parameter: {
		user: string
		database: string
	}
}
