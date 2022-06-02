targetScope = 'subscription'

@secure()
param securityToken string

output exposedSecret string = securityToken
