https://kubevela.io/docs/platform-engineers/cue/definition-edit  
initialize new trait template:  
```vela def init my-trait -t trait --desc "My trait description."```
```vela def init my-comp --interactive```

initialize new component from exisiting yaml:  
```vela def init postgres-db-helm -t component --desc "My component." --template-yaml ./postgres-helm-argo.yaml > db-postgres.cue```

validate a definition:  
```vela def vet db-postgres.cue```

show the generated kubernetes yaml file:  
```vela def apply db-postgres.cue --dry-run```

or for applications:  
```vela dry-run -f application.yaml```

deploy cue file:  
```vela def apply my-comp.cue --namespace my-namespace```

debug a deployed application:  
```vela debug <application-name>```

context informationen aus component in trait verwenden:
https://kubevela.io/docs/platform-engineers/traits/customize-trait => Get context data of Component parameters

