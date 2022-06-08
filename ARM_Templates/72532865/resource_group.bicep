targetScope = 'subscription'

param name string
param location string
param resourceSuffix string

resource resource_group 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: name
  location: location
}

module storage_account 'storage_account.bicep' = {
  scope: resourceGroup(name)
  name: 'storage_account'
  params: {
    location: location
    resourceSuffix: resourceSuffix
  }
  dependsOn: [
    resource_group
  ]
}
