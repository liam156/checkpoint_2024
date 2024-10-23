# DevOps Microservices Project

## Introduction

This project consists of two microservices written in Python, deployed on AWS ECS using Docker containers. The microservices communicate via Amazon SQS and store processed data in an S3 bucket. The entire infrastructure is defined using Terraform, and a CI/CD pipeline is implemented using Jenkins to automate the build, test, and deployment process.

## Project Structure

```bash
├── microservice1
│   ├── app.py              # Flask API for receiving requests and sending messages to SQS
│   ├── Dockerfile          # Dockerfile for microservice 1
│   ├── requirements.txt    # Dependencies for microservice 1
├── microservice2
│   ├── worker.py           # SQS worker that pulls messages from SQS and stores them in S3
│   ├── Dockerfile          # Dockerfile for microservice 2
│   ├── requirements.txt    # Dependencies for microservice 2
├── terraform               # Terraform code to create AWS resources (VPC, ECS, ELB, S3, SQS)
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── Jenkinsfile             # CI/CD pipeline configuration for Jenkins
└── README.md               # Project documentation
