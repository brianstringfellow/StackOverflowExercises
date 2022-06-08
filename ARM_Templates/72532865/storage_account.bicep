param resourceSuffix string
param location string

resource storage_account 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'sa${resourceSuffix}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
