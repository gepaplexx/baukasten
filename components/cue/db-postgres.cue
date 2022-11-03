        output: {
          apiVersion: "argoproj.io/v1alpha1"
          kind:       "Application"
          metadata: name: parameter.name
          spec: {
              destination: {
                  namespace: context.namespace
                  server: 'https://kubernetes.default.svc'
              }
              project: "default"
              source: {
                  chart: 'postgresql'
                  repoURL: 'https://charts.bitnami.com/bitnami'
                  targetRevision: '11.0.3' # TODO make it configerable
              }
              syncPolicy: {
                  automated: {
                      prune: true
                      selfHeal: true
                  }
              }
          }
        }