param privateEndpointName string

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-08-01' existing = {
  name: privateEndpointName
}

module networkInterface 'nested.bicep' = {
  name: 'nested'
  params: {
    nicName: last(split(privateEndpoint.properties.networkInterfaces[0].id, '/'))
  }
}

output nicIpAddress string = networkInterface.outputs.ip
