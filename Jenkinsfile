pipeline {
    agent any

    tools {
        nodejs 'NodeJS'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build/Install') {
            steps {
                sh 'npm install'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Static Analysis') {
            environment {
                scannerHome = tool 'SonarScanner'
            }
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.host.url=http://sonarqube:9000"
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        // NEW STAGES FOR EXERCICE 2 (CD)

        stage('Docker Build') {
            steps {
                echo 'Building Docker Image...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    // ${BUILD_NUMBER} is a built-in Jenkins variable (e.g., 1, 2, 3...)
                    sh 'docker build -t $DOCKER_USER/devops-tp-node:$BUILD_NUMBER .'
                }
            }
        }

        stage('Image Scanning (Trivy)') {
            steps {
                echo 'Scanning image for vulnerabilities...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    // We run Trivy as a temporary container to scan the image we just built
                    // --exit-code 0 means it will print the report but won't fail the pipeline for now
                    sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --exit-code 0 --severity HIGH,CRITICAL $DOCKER_USER/devops-tp-node:$BUILD_NUMBER'
                }
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Pushing image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $DOCKER_USER/devops-tp-node:$BUILD_NUMBER'
                }
            }
        }
    }
}