@description('Logic App name')
param name string

@description('Location')
param location string

@description('Resource tags')
param tags object = {}

@description('Key Vault URI for secret retrieval')
param keyVaultUri string

@description('Key Vault secret name for the GitHub PAT')
param secretName string = 'github-dispatch-token'

@description('GitHub repo for workflow dispatch (owner/repo format)')
param githubRepo string

@description('GitHub workflow file name to dispatch')
param githubWorkflowFile string

@description('Git ref to dispatch on')
param githubRef string = 'main'

// Bicep string interpolation constructs the Logic App expression with embedded single quotes
#disable-next-line no-hardcoded-env-urls
var secretRetrievalUri = '${keyVaultUri}secrets/${secretName}?api-version=7.4'
var sq = '''
'
'''
var bearerExpression = 'Bearer @{body(${sq}Get_GitHub_Token${sq}).value}'

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      triggers: {
        manual: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: {}
          }
        }
      }
      actions: {
        Get_GitHub_Token: {
          type: 'Http'
          inputs: {
            method: 'GET'
            uri: secretRetrievalUri
            authentication: {
              type: 'ManagedServiceIdentity'
            }
          }
          runtimeConfiguration: {
            secureData: {
              properties: [
                'inputs'
                'outputs'
              ]
            }
          }
        }
        Dispatch_Workflow: {
          type: 'Http'
          runAfter: {
            Get_GitHub_Token: [
              'Succeeded'
            ]
          }
          inputs: {
            method: 'POST'
            uri: 'https://api.github.com/repos/${githubRepo}/actions/workflows/${githubWorkflowFile}/dispatches'
            headers: {
              Authorization: bearerExpression
              Accept: 'application/vnd.github+json'
              'X-GitHub-Api-Version': '2022-11-28'
            }
            body: {
              ref: githubRef
            }
          }
          runtimeConfiguration: {
            secureData: {
              properties: [
                'inputs'
                'outputs'
              ]
            }
          }
        }
        Send_Response: {
          type: 'Response'
          runAfter: {
            Dispatch_Workflow: [
              'Succeeded'
            ]
          }
          inputs: {
            statusCode: 200
            body: {
              status: 'dispatched'
            }
          }
        }
      }
    }
  }
}

resource trigger 'Microsoft.Logic/workflows/triggers@2019-05-01' existing = {
  name: 'manual'
  parent: logicApp
}

output principalId string = logicApp.identity.principalId
output triggerUrl string = trigger.listCallbackUrl().value
output id string = logicApp.id
