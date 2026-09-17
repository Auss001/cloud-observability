pipeline {
    agent any

    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
        APP_HOST = '10.0.2.2'
        PROMETHEUS_HOST = '10.0.1.3'
    }

    stages {
        stage('Lint & Validate') {
            steps {
                echo 'Validating Ansible syntax...'
                sh 'ansible-playbook -i ansible/inventory/hosts.ini ansible/site.yml --syntax-check'
            }
        }

        stage('Deploy via Ansible') {
            steps {
                echo 'Deploying configuration and application updates across fleet...'
                sh 'ansible-playbook -i ansible/inventory/hosts.ini ansible/site.yml'
            }
        }

        stage('Smoke Test Application') {
            steps {
                echo 'Testing HTTP endpoint availability...'
                sh 'curl -f -s -I http://${APP_HOST} | grep "200 OK"'
            }
        }

        stage('Verify Observability Health') {
            steps {
                echo 'Checking Prometheus target status...'
                sh '''
                    STATUS=$(curl -s http://${PROMETHEUS_HOST}:9090/api/v1/targets | grep -o '"health":"up"' | wc -l)
                    echo "Active healthy targets: ${STATUS}"
                    if [ "$STATUS" -lt 1 ]; then
                        echo "Prometheus targets are unhealthy!"
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo "CI/CD Pipeline finished successfully! App and telemetry are verified."
        }
        failure {
            echo "Pipeline failed. Check stage logs for details."
        }
    }
}