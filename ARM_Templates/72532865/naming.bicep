targetScope = 'subscription'

param runningNumber string
param descriptionShort string
param function string
param regionShort string
param environment string

output resourceGroupName string = 'rg-${runningNumber}-${descriptionShort}-${function}-${regionShort}-${environment}'
output resourceNameSuffix string = '${runningNumber}${descriptionShort}${function}${regionShort}${environment}'
