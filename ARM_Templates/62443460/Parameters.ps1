$parameters = @{
  'keyVaultName' = 'so62443460'
  'policies' = @(
    @{
        'tenantId' = '<GUID-tenantId>'
        'objectId' = '<GUID-objectId0>'
        'keys' = @()
        'secrets' = @('get')
        'certificates' = @()
    },
    @{
        'tenantId' = '<GUID-tenantId>'
        'objectId' = '<GUID-objectId1>'
        'keys' = @()
        'secrets' = @()
        'certificates' = @('list')
    }
  )
}