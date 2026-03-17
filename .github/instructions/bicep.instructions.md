---
applyTo: "infra/**/*.bicep"
---

# Bicep Infrastructure Instructions

When editing Bicep infrastructure files:

- Use modular structure: `infra/main.bicep` orchestrates, `infra/modules/` contains individual resources
- Use `@description` decorators on all parameters
- Target low-cost SKUs: ACR Basic, Container Apps Consumption, Log Analytics free tier
- Container Apps should use scale-to-zero (minReplicas: 0) for cost optimization
- Use system-assigned managed identity for ACR pull access (not admin credentials in production)
- Always parameterize resource names and locations
- Use `targetScope = 'resourceGroup'` for main.bicep
