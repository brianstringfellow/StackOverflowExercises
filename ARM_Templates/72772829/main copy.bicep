param privateEndpointName string = 'sspnuse2sa00-blob-privateendpoint'

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-08-01' existing = {
  name: privateEndpointName
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-08-01' existing = {
  name: last(split(privateEndpoint.properties.networkInterfaces[0].id, '/'))
}

output privateEndpointId string = privateEndpoint.id
output nicIdByPe string = privateEndpoint.properties.networkInterfaces[0].id
output nicIdByDirect string = networkInterface.name
output nicIpAddress object = networkInterface.properties.ipConfigurations[0]



// /subscriptions/e6dc771a-4a9a-4ccf-9b75-faabead09acb
// /resourceGroups/SSP-NonProd-USE2-Ancillary
// /providers/Microsoft.Network/networkInterfaces/sspnuse2sa00-blob-privateendpoint.nic.57e5d57c-b6a9-474b-9aa1-af9e96eb86c6
// /ipConfigurations/privateEndpointIpConfig.ff2d2df8-034b-4ead-8e3e-d8125f56931e
