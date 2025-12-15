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
                script {
                    sh "podman build --format docker -t ${REGISTRY_URL}/${REGISTRY_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ."
                    sh "podman tag ${REGISTRY_URL}/${REGISTRY_USER}/${IMAGE_NAME}:${BUILD_NUMBER} ${REGISTRY_URL}/${REGISTRY_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
        stage('Push to GitHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-container-registry', passwordVariable: 'REGISTRY_PASS', usernameVariable: 'LOGIN_USER')]) {
                    sh "podman login -u ${LOGIN_USER} -p ${REGISTRY_PASS} ${REGISTRY_URL}"
                    sh "podman push ${REGISTRY_URL}/${REGISTRY_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    sh "podman push ${REGISTRY_URL}/${REGISTRY_USER}/${IMAGE_NAME}:latest"
                }
            }
        }
        stage('Deploy to System') {
            steps {
                script {
                    echo "Deploying to Systemd..."
                    // This block fixes the DBUS/User error you saw!
                    sh '''
                        export XDG_RUNTIME_DIR=/run/user/$(id -u)
                        export DBUS_SESSION_BUS_ADDRESS=unix:path=${XDG_RUNTIME_DIR}/bus

                        # Reload to pick up changes and restart the app
                        systemctl --user daemon-reload
                        systemctl --user restart demo-app
                    '''
                }
            }
        }
        stage('Security Scan') {
            steps {
                echo 'Running Trivy Security Scan...'
                // 1. Fail the build if CRITICAL vulnerabilities are found
                sh 'trivy image --exit-code 1 --severity CRITICAL --no-progress ghcr.io/rdx463/podman_demo:latest'
                
                // 2. Just print HIGH/MEDIUM/LOW for info (don't fail build)
                sh 'trivy image --exit-code 0 --severity HIGH,MEDIUM,LOW --no-progress ghcr.io/rdx463/podman_demo:latest'
            }
        }
    }
}
