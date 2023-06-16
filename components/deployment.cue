import (
	"strconv"
	"strings"
)

deployment: {
	alias: ""
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "apps/v1"
		kind:       "Deployment"
	}
	description: "A component to deploy a Backend Service."
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "apps/v1"
		kind:       "Deployment"
		metadata: {
			name: context.name
			namespace: parameter.namespace
		}
		spec: {
			replicas: parameter.replicas
			selector: matchLabels: {
				"app.oam.dev/component": context.name
				"app.oam.dev/type": "deployment"
			}
			template: {
				metadata: labels: {
					"app.oam.dev/component": context.name
					"app.oam.dev/type": "deployment"
				}
				spec: {
					containers: [{
						name: context.name
						if parameter["env"] != _|_ for e in parameter["env"] {
							env: [
								for i, v in parameter.env {
									name: v.name
									if v.valueFrom != _|_ {
										valueFrom: {
											if v.valueFrom.configMapKeyRef != _|_ {
												configMapKeyRef: {
													name: v.valueFrom.configMapKeyRef.name
													key: v.valueFrom.configMapKeyRef.key
												}
											}

											if v.valueFrom.secretKeyRef != _|_ {
												secretKeyRef: {
													name: v.valueFrom.secretKeyRef.name
													key: v.valueFrom.secretKeyRef.key
												}
											}

											if v.valueFrom.hcVault != _|_ {
												secretKeyRef: {
													name: context.name + "-secret"
													// name: parameter.name + "_" + strings.Replace(v.valueFrom.hcVault.key, "/", "_", -1)
													key: v.valueFrom.hcVault.property
												}
											}
										}
									}

									if v.value != _|_ {
										value: v.value
									}
								}
							]
						}
						image: parameter.image + ":" + parameter.tag
						if parameter["port"] != _|_ && parameter["ports"] == _|_ {
							ports: [{
								containerPort: parameter.port
							}]
						}
						if parameter["ports"] != _|_ {
							ports: [ for v in parameter.ports {
							{
								containerPort: v.port
								if v.name != _|_ {
									name: v.name
								}
							}
						}]
						}
						resources: parameter.resources
					}]
				}
			}
		}
	}
	outputs: {
		service: {
			apiVersion: "v1"
			kind:       "Service"
			metadata: {
				name: context.name
				namespace: parameter.namespace
			}
			spec: {
				selector: "app.oam.dev/component": context.name
				ports: exposePorts
				type:  parameter.exposeType
			}
		}

  	if parameter.ports != _|_ for p in parameter.ports if p.expose == true {
    	route: {
      	apiVersion: "route.openshift.io/v1"
      	kind: "Route"
      	metadata: {
      		name: context.name
					namespace: parameter.namespace
					annotations: {
						"cert-manager.io/cluster-issuer": "letsencrypt-production"
					}
      	}
      	spec: {
      		if parameter.host != _|_ {
      			host: parameter.route.host
      		}
        	to: {
        		kind: "Service"
        		name: context.name
        	}
        	if p.name != _|_ {
          	port: targetPort: p.name
        	}
        	if p.name == _|_ {
          	port: targetPort: "port-" + strconv.FormatInt(p.port, 10)
        	}
        	tls: {
          	termination: parameter.route.termination
          	insecureEdgeTerminationPolicy: parameter.route.insecureEdgeTerminationPolicy
          	if parameter.route.certificate != _|_ {
          		certificate: parameter.route.certificate
          	}
          	if parameter.route.key != _|_ {
          		key: parameter.route.key
          	}
						if parameter.route.caCertificate != _|_ {
							caCertificate: parameter.route.caCertificate
						}
						if parameter.route.destinationCACertificate != _|_ {
							destinationCACertificate: parameter.route.destinationCACertificate
						}
        	}
        	wildcardPolicy: "None"
      	}
    	}
  	}

  	if len(parameter.env) > 0 {
  			_data: [for _, v in parameter.env if v.valueFrom.hcVault != _|_ {
  				remoteRef: {
  					key: v.valueFrom.hcVault.key
						property: v.valueFrom.hcVault.property
					}
					secretKey: v.valueFrom.hcVault.property
  			}]
  			_target: [for _, v in parameter.env if v.valueFrom.hcVault != _|_ {
  				"\(v.valueFrom.hcVault.property)": "{{ ." + v.valueFrom.hcVault.property + " }}"
  			}]
  			if len(_data) > 0 {
  				externalSecret: {
  					apiVersion: "external-secrets.io/v1beta1"
						kind: "ExternalSecret"
						metadata: {
							name: context.name + "-external-secret"
							namespace: parameter.namespace
						}
						spec: {
							data: _data
							secretStoreRef: {
								name: parameter.secretStoreName
								kind: "ClusterSecretStore"
							}
							target: {
								name: context.name + "-secret"
								creationPolicy: "Owner"
								deletionPolicy: "Delete"
								template: data: {
									for _, val in _target {
										val
									}
								}
							}
						}
  				}
  			}
  	}
	}

	parameter: {
		namespace: *context.namespace | string
		replicas: *1 | string
		image: string
		tag: string
		env?: [...{
			name: string
			value?: string
			valueFrom?: {
				secretKeyRef?: {
					name: string
					key: string
				}

				configMapKeyRef?: {
					name: string
					key: string
				}

				hcVault?: {
					key: string
					property: string
				}
			}
		}]
		secretStoreName: *(context.name + "-secret-store") | string
		resources: {
			limits: {
				memory: *"400Mi" | string
			}
			requests: {
				cpu: *"100m" | string
				memory: *"128Mi" | string
			}
		}
		// +usage=Which ports do you want customer traffic sent to, defaults to 80
		ports?: [...{
			// +usage=Number of port to expose on the pod's IP address
			port: int
			// +usage=Name of the port
			name?: string
			// +usage=Specify if the port should be exposed
			expose: *false | bool
			// +usage=exposed node port. Only Valid when exposeType is NodePort
			nodePort?: int
		}]
		// +usage=Specify what kind of Service you want. options: \\\"ClusterIP\\\", \\\"NodePort\\\", \\\"LoadBalancer\\\"
  	exposeType: *"ClusterIP" | "NodePort" | "LoadBalancer"

		route: {
			host?: string
			termination: *"edge" | "passthrough" | "reencrypt"
			insecureEdgeTerminationPolicy: *"None" | "Redirect" | "Allow"
			certificate?: string
			key?: string
			caCertificate?: string
			destinationCACertificate?: string
		}
	}

// ############ HELPER ###################
exposePorts:
  [ if parameter.ports != _|_ for p in parameter.ports {
    port:       p.port
    targetPort: p.port
    if p.name != _|_ {
      name: p.name
    }
  	if p.name == _|_ {
    	name: "port-" + strconv.FormatInt(p.port, 10)
  	}
  	if p.nodePort != _|_ && parameter.exposeType == "NodePort" {
    	nodePort: p.nodePort
  	}
	}]
}


