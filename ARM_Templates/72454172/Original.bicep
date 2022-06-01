param serviceBusNamespaceName string = 'sa72454172'
param location string = 'East US'
param eventSubscriptionName string = 'eventSubName'
param storageAccountName string = 'sa${uniqueString(resourceGroup().id)}'
param deadLetterAccountName string = 'sadl${uniqueString(resourceGroup().id)}'
param serviceBusQueueName string = 'queue-name-enter'
param onrampName string = 'storagecontainername'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource deadLetterAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: deadLetterAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-11-01' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {}
}

resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2021-11-01' = {
  parent: serviceBusNamespace
  name: serviceBusQueueName
  properties: {
    lockDuration: 'PT5M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    defaultMessageTimeToLive: 'P10675199DT2H48M5.4775807S'
    deadLetteringOnMessageExpiration: false
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    maxDeliveryCount: 10
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false
  }
}

resource eventgridsubscription 'Microsoft.EventGrid/eventSubscriptions@2021-12-01' = {
  name: eventSubscriptionName
  scope: storageAccount
  properties: {
    deadLetterDestination: {
      endpointType: 'StorageBlob'
      properties: {
        blobContainerName: 'storage-deadletters'
        resourceId: deadLetterAccount.id
      }
    }
    destination: {
      endpointType: 'ServiceBusQueue'
      properties: {
        deliveryAttributeMappings: [
          {
            name: serviceBusQueueName
            type: 'Static'
            properties: {
              isSecret: false
              value: 'some-value'
            }
          }
        ]
        resourceId: serviceBusQueue.id
      }
    }
    eventDeliverySchema: 'EventGridSchema'
    filter: {
      enableAdvancedFilteringOnArrays: false
      includedEventTypes: [
        'Microsoft.Storage.BlobCreated'
      ]
      isSubjectCaseSensitive: false
      subjectBeginsWith: '/blobServices/default/containers/${onrampName}'
      subjectEndsWith: '.json'
    }
    retryPolicy: {
      eventTimeToLiveInMinutes: 1440
      maxDeliveryAttempts: 5
    }
  }
}
