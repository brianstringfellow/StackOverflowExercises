targetScope = 'subscription'

var location = 'northeurope'

var resourceNamePrefix = 'test-resource'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-10-01' = {
  name: '${resourceNamePrefix}-rg'
  location: location
}

module func 'function.bicep' = {
  name: '${deployment().name}-Func'
  scope: resourceGroup
  params: {
    resourceNamePrefix: resourceNamePrefix
    location: location
  }
}
