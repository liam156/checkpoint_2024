pipeline {
    agent any
    environment {
        DOCKER_REPO = 'your-docker-repo'
        AWS_CLI = '/usr/local/bin/aws'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    docker.build("${DOCKER_REPO}/microservice1:latest", './microservice1')
                    docker.build("${DOCKER_REPO}/microservice2:latest", './microservice2')
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        docker.image("${DOCKER_REPO}/microservice1:latest").push()
                        docker.image("${DOCKER_REPO}/microservice2:latest").push()
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh "${AWS_CLI} ecs update-service --cluster app-cluster --service microservice1-service --force-new-deployment"
                    sh "${AWS_CLI} ecs update-service --cluster app-cluster --service microservice2-service --force-new-deployment"
                }
            }
        }
    }
}