@description('Key Vault name (must be globally unique, 3-24 alphanumeric + hyphens)')
param name string

@description('Location')
param location string

@description('Resource tags')
param tags object = {}

@secure()
@description('GitHub PAT value to store as a secret (optional)')
param githubDispatchToken string = ''

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
  }
}

resource githubPatSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = if (!empty(githubDispatchToken)) {
  parent: keyVault
  name: 'github-dispatch-token'
  properties: {
    value: githubDispatchToken
  }
}

output name string = keyVault.name
output vaultUri string = keyVault.properties.vaultUri
output id string = keyVault.id
