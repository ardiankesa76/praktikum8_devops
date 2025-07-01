pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/ardiankesa76/praktikum8_devops.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'docker build -t php-ci-cd .'
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'docker run --rm php-ci-cd phpunit tests'
            }
        }

        stage('Deploy with Docker') {
            steps {
                sh 'docker run -d -p 8081:80 php-ci-cd'
            }
        }
    }
}
