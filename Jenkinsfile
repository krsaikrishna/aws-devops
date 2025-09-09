pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')  // Jenkins stored creds
        DOCKERHUB_REPO = "your-dockerhub-username/aws-devops-cicd-demo"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-username/aws-devops-cicd-demo.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'npm install'
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "${DOCKERHUB_REPO}:${BUILD_NUMBER}"
                    sh "docker build -t ${imageTag} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    def imageTag = "${DOCKERHUB_REPO}:${BUILD_NUMBER}"
                    sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                    sh "docker push ${imageTag}"
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    def imageTag = "${DOCKERHUB_REPO}:${BUILD_NUMBER}"
                    sh """
                    ssh -o StrictHostKeyChecking=no ec2-user@<EC2-Public-IP> '
                        docker pull ${imageTag} &&
                        docker stop app || true &&
                        docker rm app || true &&
                        docker run -d --name app -p 3000:3000 ${imageTag}
                    '
                    """
                }
            }
        }
    }
}

