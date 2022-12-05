import (
	"strconv"
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
						if parameter["env"] != _|_ {
							env: parameter.env
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
			metadata: name: context.name
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
      	metadata: name: context.name
      	spec: {
        	to: name: context.name
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
			}
		}]
		resources: {
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

