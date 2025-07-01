pipeline {
    agent any

    stages {
        stage('Install Dependencies') {
            steps {
                echo '🔧 Building Docker image...'
                sh 'docker build -t php-ci-cd .'
            }
        }

        stage('Run Unit Tests') {
            steps {
                echo '🧪 Running unit tests with PHPUnit...'
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    sh 'docker run --rm php-ci-cd phpunit tests'
                }
            }
        }

        stage('Deploy with Docker') {
            steps {
                echo '🚀 Deploying Docker container to port 8081...'
                sh 'docker run -d -p 8081:80 --name php_app php-ci-cd'
            }
        }
    }

    post {
        success {
            echo '✅ Build and deployment successful!'
        }
        failure {
            echo '❌ Build failed. Please check the logs.'
        }
    }
}
