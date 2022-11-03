import (
    "strconv"
)
output: {
    apiVersion: "apps/v1"
    kind:       "Deployment"
    spec: {
        selector: matchLabels: {
            "app.oam.dev/component": context.name
        }
        template: {
            metadata: labels: {
                "app.oam.dev/component": context.name
            }
            spec: {
                containers: [{
                    name:  context.name
                    image: parameter.image
                    if parameter["env"] != _|_ {
                        env: parameter.env
                    }
                    if parameter["port"] != _|_ && parameter["ports"] == _|_ {
                        ports: [{
                            containerPort: parameter.port
                        }]
                    }
                    if parameter["ports"] != _|_ {
                        ports: [ for v in parameter.ports {
                            {
                                containerPort: v.port
                                protocol: v.protocol
                                if v.name != _|_ {
                                    name: v.name
                                }
                            }
                        }]
                    }
                }]
            }
        }
    }
}
exposePorts:
    [if parameter.ports != _|_ for v in parameter.ports if v.expose == true {
        port:       v.port
        targetPort: v.port
        if v.name != _|_ {
            name:
        v.name
        }
        if v.name == _|_ {
            name: strconv.FormatInt(v.port, 10)
        }
        if v.nodePort != _|_ && parameter.exposeType == "NodePort" {
            nodePort: v.nodePort
        }
    },
    ]
outputs: {
    service: {
    apiVersion: "v1"
    kind: "Service"
    metadata: name: context.name
    spec: {
        selector: "app.oam.dev/component": context.name
        ports: exposePorts
        type:  parameter.exposeType
    }
    }
}
outputs: {
    if len(exposePorts) != 0 {
    route: {
        apiVersion: "route.openshift.io/v1"
        kind: "Route"
        metadata: name: context.name
        spec: {
            to: name: context.name
            port: targetPort: "http"
            tls: {
                termination: "edge"
                insecureEdgeTerminationPolicy: "None"
            }
            wildcardPolicy: "None"
        }
    }
    }
}        

parameter: {
    image: string
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
    // +usage=Which ports do you want customer traffic sent to, defaults to 80
    ports?: [...{
        // +usage=Number of port to expose on the pod's IP address
        port: int
        // +usage=Name of the port
        name?: string
        // +usage=Protocol for port. Must be UDP, TCP, or SCTP
        protocol: *"TCP" | "UDP" | "SCTP"
        // +usage=Specify if the port should be exposed
        expose: *false | bool
        // +usage=exposed node port. Only Valid when exposeType is NodePort
        nodePort?: int
    }]
}