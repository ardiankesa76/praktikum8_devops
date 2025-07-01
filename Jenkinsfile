pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                echo '⚙️ Checking out code from GitHub...'
                git branch: 'main', url: 'https://github.com/ardiankesa76/praktikum8_devops.git'
            }
        }

        stage('Build Docker Image') {
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

        stage('Deploy') {
            steps {
                echo '🚀 Deploying app to localhost:8081...'

                // ✅ FIX: Hentikan dan hapus container lama sebelum deploy
                sh 'docker stop php_app || true'
                sh 'docker rm php_app || true'

                // Jalankan container baru
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
        always {
            echo '🧹 Cleaning up any existing php_app container...'
            sh 'docker stop php_app || true'
            sh 'docker rm php_app || true'
        }
    }
}
