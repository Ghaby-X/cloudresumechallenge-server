# Server-Side implementation for Resume Cloud Challenge

This repository contains the server-side code and infrastructure for the Resume Cloud Challenge. The server-side is responsible for handling API requests to update and retrieve the visitor count, as well as managing cloud resources such as Azure Function Apps and Storage Accounts.

## Table of Contents

    Overview
    Server Architecture
    Provisioning Cloud Resources with Terraform
    Python Function to Update Visitor Count
    CI/CD Pipeline for Server
    Deployment Instructions
    Technologies Used

## Overview

The server-side implementation is built using Azure Functions and Azure Storage services. The main functionality includes:

    Azure Function to handle HTTP requests that update the visitor count in the Azure Storage Table.
    Azure Storage Account to store the visitor count data.
    Terraform to provision Azure resources like the Function App and Storage Account.
    CI/CD Pipeline (GitHub Actions) to automate deployment to Azure whenever there are code changes.

This project demonstrates a cloud-native architecture that is scalable, serverless, and easy to deploy.
Server Architecture

The architecture is composed of the following components:

    Azure Function App: A serverless function that triggers on HTTP requests. The function increments the visitor count stored in the Azure Storage Table.
    Azure Storage Account: A storage service used to hold data. This includes a table that tracks the visitor count.
    Terraform: Used for provisioning and managing Azure resources such as the Function App and Storage Account.
    CI/CD Pipeline: Automated deployment pipeline via GitHub Actions for continuous deployment of the server-side code.

Provisioning Cloud Resources with Terraform

This project uses Terraform to provision the following Azure resources:

    Function App: Runs the Python function to update the visitor count.
    Storage Account: Stores the visitor count in a table.
    Storage Container: Used for other potential static resources.

Steps to Provision Resources

    Install Terraform if you don't have it installed:

Set up your Azure credentials (make sure you have Azure CLI configured):

az login

Initialize Terraform to install required providers:

terraform init

Apply Terraform configuration to provision the resources:

    terraform apply

    Terraform will prompt for confirmation to create the resources. Type yes to proceed.

    After successful provisioning, Terraform will output the URLs and keys for the Function App and Storage Account.

Python Function to Update Visitor Count

The core functionality of the server-side is handled by an Azure Function written in Python. This function is responsible for:

    Accepting HTTP requests that trigger the update of the visitor count.
    Connecting to Azure Storage to retrieve and update the visitor count in the Storage Table.

Python Function Code

The Python function is located in the function folder. Here is a simplified version of the core code:

import azure.functions as func
from azure.storage.table import TableServiceClient


This function:

    Connects to the Azure Storage Table to retrieve the current visitor count.
    Increments the count by one each time the function is triggered.
    Returns the updated count in the HTTP response.

Function App Configuration

You can configure the function app in the Azure portal or using terraform. The function is triggered by an HTTP request, which makes it suitable for a RESTful API.
CI/CD Pipeline for Server

The server-side code is automatically deployed to Azure via a CI/CD pipeline set up with GitHub Actions.
GitHub Actions Workflow

The .github/workflows/azure-functions.yml file automates the deployment process whenever there is a change pushed to the repository.


Secrets Required:

    AZURE_CLIENT_ID: Azure Service Principal ID
    AZURE_CLIENT_SECRET: Azure Service Principal Secret
    AZURE_TENANT_ID: Azure Tenant ID

This setup ensures that whenever changes are pushed to the main branch, the function app will automatically update in Azure.
Deployment Instructions


Technologies Used

    Azure Functions (Python)
    Azure Storage Account (for storing visitor count)
    Terraform (for infrastructure as code)
    GitHub Actions (for CI/CD)

If you have any questions or need further assistance, feel free to open an issue or contribute to the repository. Happy coding!

This README is specifically for the server-side implementation, covering the Azure Functions, Terraform setup, and CI/CD pipelines used to deploy the backend components.
