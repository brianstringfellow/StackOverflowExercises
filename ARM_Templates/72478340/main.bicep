param location string = 'East US'

resource hostingPlan 'Microsoft.Web/serverfarms@2021-01-15' = {
  name: 'apphostingplanname'
  location: location
  properties: {
    reserved: true
  }
  sku: {
    tier: 'Standard'
    name: 'S1'
  }
  kind: 'linux'
}

resource resourceName_resource 'Microsoft.Web/sites@2021-02-01' = {
  name: 'somewebapp72478340'
  location: location
  identity: {
    type: 'SystemAssigned'
 }
  tags: {
    'hidden-related:${hostingPlan.id}': 'empty'
  }
  kind: 'functionapp'
  properties: {
    httpsOnly: true
    reserved: false
    serverFarmId: hostingPlan.id
    siteConfig: {
      alwaysOn: true
      linuxFxVersion: 'DOTNETCORE|6.0'
    }
  }
}
