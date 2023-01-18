# baukasten

## Vela CLI
https://kubevela.io/docs/platform-engineers/cue/definition-edit

initialize new trait template:  
```vela def init my-trait -t trait --desc "My trait description."```

initialize new component from exisiting yaml:  
```vela def init my-component -t component --desc "My component." --template-yaml ./component-example.yaml > my-component.cue```

validate a definition:  
```vela def vet my-definition.cue```

show the generated kubernetes yaml file:  
```vela def apply my-definition.cue --dry-run```

or for applications:  
```vela dry-run -f my-application.yaml```

deploy cue file:  
```vela def apply my-component.cue --namespace my-namespace```

debug a deployed application:  
```vela debug my-app-name -n my-namespace```