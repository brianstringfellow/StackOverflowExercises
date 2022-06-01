param resourceNamePrefix string
param location string

resource serverfarm 'Microsoft.Web/serverfarms@2021-02-01' = {
  kind: 'linux'
  name: '${resourceNamePrefix}-appserviceplan'
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
  }
  properties: {
    reserved: true 
    maximumElasticWorkerCount: 1
  }
}

output serverfarmId string = serverfarm.id
