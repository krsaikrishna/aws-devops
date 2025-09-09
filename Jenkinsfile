pipeline {
    agent any
    
    environment {
         DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')
         DOCKERHUB_REPO = "krsaikrishna/aws-devops"
    }
    
    stages {
        stage('checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/krsaikrishna/aws-devops.git'
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
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    script {
                        def imageTag = "${DOCKERHUB_REPO}:${BUILD_NUMBER}"
                        sh """
                            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                            docker push ${imageTag}
                        """    
                    }
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh-key', keyFileVariable: 'SSH_KEY')]) { 
                    sh '''
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY ec2-user@18.144.52.69 '
                             docker pull krsaikrishna/aws-devops:${BUILD_NUMBER} &&
                             docker stop app || true &&
                             docker rm app || true &&
                             docker run -d --name app -p 3000:3000 krsaikrishna/aws-devops:${BUILD_NUMBER}
                        '
                    '''
                }
            }
        }
    }
}
