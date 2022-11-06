@description('Name of the VM')
param vmName string = 'stagingLinuxVM'

@description('location for all resources')
param location string = resourceGroup().location

@description('vm sizes allowed RAM & temp storage in GiB per tier (respectively): 0.5/4; 1/4; 2/4; 4/8; 8/16')
@allowed([
  'Standard_B1s'
  'Standard_B1ms'
  'Standard_B2s'
  'Standard_B2ms'
])
param vmSize string = 'Standard_B1s'

@description('Username for the VM')
param adminUsername string

@description('SSH Key for the Virtual Machine')
@secure()
param adminPasswordKey string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdNRTU0XF3xazhhDmwXXWGG7wp4AaQC1r89K7sZFRXp9VSUtydV59DHr67mV5/0DWI5Co1yWK713QJ00BPlBIHNMNLuoBBq8IkOx8fBZF1g9YFm5Zy4ay+CF4WgDITAsyxhKvUWL6jwG5M3XIdVYm49K+EFOCWSSaNtCk8tHhi3v6/5HFkwc2r0UL/WWWbbt5AmpJ8QOCDk/x+XcgCjP9vE5jYYGsFz9F6V1FdOpjVfDwi13Ibivj/w2wOZh2lQGskC+qDjd2upK13+RfWYHY3rr+ulNRPckHRhOqmZ2vlUapO4T0X9mM6ugSh1FprLP5nHdVCUls2yw4BAcSoM9NMiyafE56Xkp9h3bTAfx5Ufpe5mjwQp+j15np1pVpwDaEgk7ZeaPoZPhbalpvZGyg9KiKfs9+KUYHfGklIOHKJ3RUoPE286rg1U4LGswil5RARRSf86kBBHXaIPxy1X0N6QryeWhk0aM6LWEdl7mVbQksa7ilANnsaVMl7FSdY/Cc='

@description('name of VNET')
param virtualNetworkName string = 'vnet'

@description('name of the subnet in the virtual network')
param subnetName string = 'Subnet'

param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id)}')

var osDiskType = 'Standard_LRS'
var networkInterfaceName = '${vmName}nic'
var addressPrefix = '10.1.0.0/16'
var publicIPAddressName = '${vmName}PublicIP'
var subnetAddressPrefix = '10.1.0.0/24'
var linuxConfiguration = {
  disablePasswordAuthentication: true
  provisionVMAgent: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: adminPasswordKey
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: subnetAddressPrefix
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: publicIPAddressName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
    idleTimeoutInMinutes: 4
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      adminPassword: adminPasswordKey
      adminUsername: adminUsername
      computerName: vmName
      linuxConfiguration: linuxConfiguration
    }
    storageProfile: {
      imageReference: {
        offer: 'UbuntuServer'
        publisher: 'Canonical'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        deleteOption: 'Delete'
        diskSizeGB: 32
        osType: 'Linux'
        managedDisk: {
          storageAccountType: osDiskType
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

output adminUsername string = adminUsername
output hostname string = publicIP.properties.dnsSettings.fqdn
output sshComand string = 'ssh ${adminUsername}@${publicIP.properties.dnsSettings.fqdn}'
