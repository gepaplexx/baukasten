"postgres-db-helm": {
	alias: ""
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "<change me> apps/v1"
		kind:       "<change me> Deployment"
	}
	description: "My component."
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "argoproj.io/v1alpha1"
		kind:       "Application"
		metadata: name: "my-first-db"
		spec: {
			destination: {
				namespace: "gattma-pg"
				server:    "https://kubernetes.default.svc"
			}
			project: "default"
			source: {
				chart: "postgresql"
				helm: parameters: [{
					name:  "primary.containerSecurityContext.enabled"
					value: "false"
				}, {
					name:  "primary.podSecurityContext.enabled"
					value: "false"
				}]
				repoURL:        "https://charts.bitnami.com/bitnami"
				targetRevision: "11.0.3"
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
	outputs: {}
	parameter: {}
}

