# Resume Cloud Challenge - Server Implementation

[![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)](https://azure.microsoft.com)
[![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)](https://python.org)
[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://terraform.io)
[![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/features/actions)

A cloud-native solution for deploying static websites with real-time visitor tracking. Built on Azure's serverless architecture, this project automates infrastructure provisioning and provides scalable API endpoints to track visitor statistics. The implementation uses Azure Functions for backend operations and Azure Storage for data persistence, following Infrastructure as Code (IaC) principles with Terraform.

## Related Projects
- [Resume Cloud Challenge - Client](https://github.com/Ghaby-X/cloudresumechallenge-client) - Frontend implementation using html, css, js and storage static website

## Features

- **Serverless Architecture**: Built on Azure Functions for automatic scaling and cost optimization
- **Persistent Storage**: Utilizes Azure Storage Tables for reliable data persistence
- **Infrastructure as Code**: Complete Terraform configuration for Azure resource provisioning
- **Automated Deployment**: Integrated CI/CD pipeline using GitHub Actions
- **RESTful API**: HTTP endpoints for visitor count management

## Architecture


![image](https://github.com/user-attachments/assets/6c0e1462-78df-4965-bb2b-e7acfdf2c76a)


The solution consists of the following components:

- **Azure Function App**: Serverless HTTP-triggered functions for visitor count operations
- **Azure Storage Account**: Persistent storage for visitor statistics
- **Terraform Configuration**: IaC for Azure resource management
- **GitHub Actions Pipeline**: Automated deployment workflow

## Prerequisites

- Azure CLI installed and configured
- Terraform >=1.0.0
- Python >=3.8
- Azure Subscription
- GitHub Account (for CI/CD)

## Installation

1. Clone the Repository
```bash
git clone https://github.com/yourusername/resume-cloud-challenge
cd resume-cloud-challenge
```

2. Configure Azure Credentials
```bash
az login
az account set --subscription "<your-subscription-id>"
```

3. Initialize Terraform
```bash
cd terraform
terraform init
```

4. Deploy Infrastructure
```bash
terraform apply
```

## Configuration

### Environment Variables

Create a `local.settings.json` file in the function app directory:

```json
{
  "IsEncrypted": false,
  "Values": {
    "FUNCTIONS_WORKER_RUNTIME": "python",
    "AzureWebJobsStorage": "<storage-connection-string>",
    "STORAGE_CONNECTION_STRING": "<storage-connection-string>"
  }
}
```

### GitHub Actions Secrets

Configure the following secrets in your GitHub repository:

- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`

## Deployment

### Manual Deployment

1. Build the Function App:
```bash
cd function_app
func azure functionapp publish <your-function-app-name>
```

### Automated Deployment

The repository includes a GitHub Actions workflow that automatically deploys changes when pushed to the main branch. The workflow:

1. Validates Terraform configurations
2. Runs Python tests
3. Deploys infrastructure changes
4. Updates the Function App

## API Documentation

### Update Visitor Count
```http
POST /api/visitors
```

**Response**
```json
{
  "count": 42,
  "timestamp": "2024-01-01T12:00:00Z"
}
```

### Get Visitor Count
```http
GET /api/visitors
```

**Response**
```json
{
  "count": 42
}
```

## Local Development

1. Install dependencies:
```bash
python -m venv venv
source venv/bin/activate  # or `venv\Scripts\activate` on Windows
pip install -r requirements.txt
```

2. Run locally:
```bash
func start
```

## Testing

```bash
python -m pytest tests/
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
