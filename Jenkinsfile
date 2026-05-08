pipeline {
    agent any

    tools {
        nodejs 'NodeJS'
    }

    environment {
        // Azure SP credentials (from Jenkins secrets)
        AZ_CLIENT_ID     = credentials('azure-sp-client-id')
        AZ_CLIENT_SECRET = credentials('azure-sp-client-secret')
        AZ_TENANT_ID     = credentials('azure-sp-tenant-id')
        
        // Docker image name (coherent across all stages)
        IMAGE_NAME = 'chedli01/tp4'
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

        // stage('Static Analysis') {
        //     environment {
        //         scannerHome = tool 'SonarScanner'
        //     }
        //     steps {
        //         withSonarQubeEnv('SonarQube') {
        //             sh "${scannerHome}/bin/sonar-scanner -Dsonar.host.url=http://sonarqube:9000"
        //         }
        //     }
        // }

        // stage('Quality Gate') {
        //     steps {
        //         timeout(time: 5, unit: 'MINUTES') {
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }

        stage('Docker Build') {
            steps {
                echo "Building Docker Image: ${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                sh "docker build -t ${env.IMAGE_NAME}:${env.BUILD_NUMBER} ."
            }
        }

        // stage('Image Scanning (Trivy)') {
        //     steps {
        //         echo 'Scanning image for vulnerabilities...'
        //         // Trivy scans the image we just built
        //         sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --exit-code 0 --severity HIGH,CRITICAL ${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
        //     }
        // }

        stage('Docker Push') {
            steps {
                echo 'Pushing image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Deploy to AKS') {
         steps {
          withCredentials([
            string(credentialsId: 'azure-sp-client-id', variable: 'AZ_ID'),
            string(credentialsId: 'azure-sp-client-secret', variable: 'AZ_SECRET'),
            string(credentialsId: 'azure-sp-tenant-id', variable: 'AZ_TENANT')
        ]) {
            script {
                def imageTag = "${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                
                sh """
                    ansible-playbook ansible/playbook.yml \
                      --extra-vars "az_client_id=${AZ_ID}" \
                      --extra-vars "az_client_secret=${AZ_SECRET}" \
                      --extra-vars "az_tenant_id=${AZ_TENANT}" \
                      --extra-vars "docker_image=${imageTag}"
                """
            }
        }
    }
}
    }

    post {
        failure {
            echo "Pipeline failed!"
        }
        success {
            echo "Pipeline completed successfully! Deployed: ${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
        }
    }
}