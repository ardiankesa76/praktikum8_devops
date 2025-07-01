// Definisi pipeline
pipeline {
    // Agent 'any' berarti Jenkins akan menjalankan pipeline di agen mana pun yang tersedia.
    agent any

    // Tahapan pipeline
    stages {
        // Tahap pertama: Checkout Kode dari GitHub
        stage('Checkout Code') {
            steps {
                echo '⚙️ Checking out code from GitHub...'
                // Perintah 'git' ini akan mengkloning repositori Anda.
                // Pastikan Git terinstal di server Jenkins atau agen yang menjalankan job ini.
                // 'url' adalah URL repositori GitHub Anda.
                // 'branch' adalah cabang yang ingin Anda kloning (dalam kasus ini, 'main').
                git branch: 'main', url: 'https://github.com/ardiankesa76/praktikum8_devops.git'
            }
        }

        // Tahap kedua: Membangun Docker Image
        stage('Build Docker Image') {
            steps {
                echo '🔧 Building Docker image...'
                // Perintah shell untuk membangun Docker image.
                // Titik '.' menunjukkan Dockerfile berada di direktori saat ini (workspace Jenkins).
                sh 'docker build -t php-ci-cd .'
            }
        }

        // Tahap ketiga: Menjalankan Unit Tests
        stage('Run Unit Tests') {
            steps {
                echo '🧪 Running unit tests with PHPUnit...'
                // 'catchError' akan menangkap kesalahan dalam blok ini dan menandai build sebagai FAILURE.
                // Ini penting agar build gagal jika tes unit tidak lulus.
                catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                    // Menjalankan kontainer Docker yang baru dibangun untuk menjalankan PHPUnit.
                    // '--rm' akan menghapus kontainer setelah selesai.
                    // 'phpunit tests' adalah perintah yang dijalankan di dalam kontainer.
                    sh 'docker run --rm php-ci-cd phpunit tests'
                }
            }
        }

        // Tahap keempat: Deploy Aplikasi
        stage('Deploy') {
            steps {
                echo '🚀 Deploying app to localhost:8081...'
                // Menjalankan kontainer Docker di latar belakang ('-d').
                // '-p 8081:80' memetakan port 8081 di host ke port 80 di kontainer.
                // '--name php_app' memberikan nama pada kontainer untuk memudahkan pengelolaan.
                sh 'docker run -d -p 8081:80 --name php_app php-ci-cd'
            }
        }
    }

    // Aksi setelah pipeline selesai (post-build actions)
    post {
        // Jika pipeline berhasil
        success {
            echo '✅ Build and deployment successful!'
        }
        // Jika pipeline gagal
        failure {
            echo '❌ Build failed. Please check the logs.'
        }
    }
}