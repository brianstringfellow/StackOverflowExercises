param location string
param resourceNamePrefix string
param networking object = {}

module serverfarm 'appServicePlan.bicep' = {
  name: '${deployment().name}-AppSvcPlan'
  params: {
    resourceNamePrefix: resourceNamePrefix
    location: location
  }
}

var siteConfig = {
  linuxFxVersion: 'DOTNET-ISOLATED|6.0'
  http20Enabled: true
  alwaysOn: true
  ftpsState: 'Disabled'
  functionAppScaleLimit: 1
  minimumElasticInstanceCount: 1
  vnetRouteAllEnabled: !empty(networking)
}

var basicProperties = {
  serverFarmId: serverfarm.outputs.serverfarmId
  httpsOnly: true
  redundancyMode: 'None'
  reserved: true
  siteConfig: siteConfig
}

var networkingProperties = empty(networking) ? {} : {
  virtualNetworkSubnetId: networking.subnetResourceId
}
var functionProperties = union(basicProperties, networkingProperties)

resource function 'Microsoft.Web/sites@2021-02-01' = {
  name: '${resourceNamePrefix}-fn'
  location: location
  kind: 'functionapp,linux'
  properties: functionProperties
}
