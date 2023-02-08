"db-postgres-es": {
	alias: ""
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "argoproj.io/v1alpha1"
		kind:       "Application"
	}
	description: "A component to deploy a Postgres Database with ArgoCD (using external secrets)."
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
					name: "auth.existingSecret"
					value: context.name + "-connector"
				}, {
					name: "auth.username"
					value: parameter.user
				}, {
					name: "auth.database"
					value: parameter.database
				}, {
					name: "auth.secretKeys.adminPasswordKey"
					value: "admin-password"
				}, {
					name: "auth.secretKeys.userPasswordKey"
					value: "user-password"
				}]
				repoURL:        "https://charts.bitnami.com/bitnami"
				targetRevision: parameter.postgresHelmChartVersion
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
		connector: {
			apiVersion: "external-secrets.io/v1beta1"
			kind: "ExternalSecret"
			metadata: name: context.name + "-connector"
			spec: {
				data: [{
					remoteRef: {
						conversionStrategy: "Default"
						decodingStrategy:   "None"
						key:                parameter.vaultKey
						property:           parameter.vaultUserPWProperty
					}
					secretKey: "userPassword"
				}, {
					remoteRef: {
						conversionStrategy: "Default"
						decodingStrategy:   "None"
						key:                parameter.vaultKey
						property:           parameter.vaultAdminPWProperty
					}
					secretKey: "adminPassword"
				}]
				secretStoreRef: {
					name: parameter.secretStoreName
					kind: "ClusterSecretStore"
				}
				target: {
					name:           context.name + "-connector"
					creationPolicy: "Owner"
					deletionPolicy: "Delete"
					template: data: {
						"admin-password": 	"{{ .adminPassword }}"
						db:				          parameter.database
						jdbcUrl:       			"jdbc:postgresql://" + context.name + "-postgresql/" + parameter.database
						"user-password":    "{{ .userPassword }}"
						username:						parameter.user
					}
				}
			}
		}
	}
	parameter: {
		user: string
		database: string
		vaultKey: string
		vaultUserPWProperty: string
		vaultAdminPWProperty: string
		postgresHelmChartVersion: *"12.1.9" | string
		secretStoreName: context.name + "-cluster-store" | string
	}
}
