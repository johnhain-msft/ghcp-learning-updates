@description('Application Insights name')
param name string

@description('Location')
param location string

@description('Resource tags')
param tags object = {}

@description('Log Analytics workspace resource ID')
param logAnalyticsWorkspaceId string

@description('URL to monitor with availability test')
param availabilityTestUrl string

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceId
    RetentionInDays: 30
  }
}

resource availabilityTest 'Microsoft.Insights/webtests@2022-06-15' = {
  name: '${name}-ping'
  location: location
  tags: union(tags, {
    'hidden-link:${appInsights.id}': 'Resource'
  })
  kind: 'standard'
  properties: {
    SyntheticMonitorId: '${name}-ping'
    Name: '${name} Availability Test'
    Enabled: true
    Frequency: 300
    Timeout: 30
    Kind: 'standard'
    RetryEnabled: true
    Locations: [
      { Id: 'us-va-ash-azr' }
      { Id: 'us-il-ch1-azr' }
      { Id: 'us-ca-sjc-azr' }
    ]
    Request: {
      RequestUrl: availabilityTestUrl
      HttpVerb: 'GET'
      ParseDependentRequests: false
    }
    ValidationRules: {
      ExpectedHttpStatusCode: 200
      SSLCheck: true
      SSLCertRemainingLifetimeCheck: 7
    }
  }
}

output appInsightsId string = appInsights.id
output instrumentationKey string = appInsights.properties.InstrumentationKey
output connectionString string = appInsights.properties.ConnectionString
