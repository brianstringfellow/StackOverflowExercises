targetScope = 'subscription'

var location = 'East US 2'

module naming 'naming.bicep' = {
  name: 'naming'
  params: {
    descriptionShort: 'app'
    environment: 'n'
    function: 't'
    regionShort: 'use2' 
    runningNumber: 'aa'
  }
}

module resource_group 'resource_group.bicep' = {
  name: 'resource_group'
  params: {
    name: naming.outputs.resourceGroupName
    location: location
    resourceSuffix: naming.outputs.resourceNameSuffix
  }
}
