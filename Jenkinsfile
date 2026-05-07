pipeline {
    agent any

    // This makes the NodeJS tool we configured available in the pipeline path
    tools {
        nodejs 'NodeJS'
    }

    stages {
        stage('Checkout') {
            steps {
                // Pulls the code from your Git repo
                checkout scm
            }
        }

        stage('Build/Install') {
            steps {
                echo 'Installing dependencies...'
                sh 'npm install'
            }
        }

        stage('Unit Tests') {
            steps {
                echo 'Running unit tests...'
                sh 'npm test'
            }
        }

        stage('Static Analysis') {
            environment {
                // Link to the Scanner we configured in Jenkins Tools
                scannerHome = tool 'SonarScanner'
            }
            steps {
                echo 'Running SonarQube Analysis...'
                // Points to the SonarQube container inside our Docker network
                withSonarQubeEnv('SonarQube') {
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.host.url=http://sonarqube:9000"
                }
            }
        }

        stage('Quality Gate') {
            steps {
                echo 'Waiting for SonarQube Quality Gate...'
                timeout(time: 5, unit: 'MINUTES') {
                    // Pipeline fails here if SonarQube metrics aren't met
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}