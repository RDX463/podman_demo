pipeline {
    agent any
    environment {
        REGISTRY_USER = 'rdx463'
        IMAGE_NAME = 'podman_demo'
        REGISTRY_URL = 'ghcr.io'
    }
    stages {
        stage('Build Image') {
            steps {
                sh "podman build --format docker -t ${REGISTRY_URL}/${REGISTRY_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }
        stage('Push to GitHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-container-registry', passwordVariable: 'REGISTRY_PASS', usernameVariable: 'LOGIN_USER')]) {
                    sh "podman login -u ${LOGIN_USER} -p ${REGISTRY_PASS} ${REGISTRY_URL}"
                    sh "podman push ${REGISTRY_URL}/${REGISTRY_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }
    }
}
