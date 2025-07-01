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
                    sh 'docker build -t php-ci-cd .'
                }
            }

            // Tahap ketiga: Menjalankan Unit Tests
            stage('Run Unit Tests') {
                steps {
                    echo '🧪 Running unit tests with PHPUnit...'
                    catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
                        sh 'docker run --rm php-ci-cd phpunit tests'
                    }
                }
            }

            // Tahap keempat: Deploy Aplikasi
            stage('Deploy') {
                steps {
                    echo '🚀 Deploying app to localhost:8081...'
                    // --- TAMBAHAN BARU: HENTIKAN DAN HAPUS KONTAINER LAMA JIKA ADA ---
                    // Perintah 'docker stop' akan menghentikan kontainer jika sedang berjalan.
                    // '|| true' memastikan langkah ini tidak menyebabkan build gagal jika kontainer tidak ada.
                    sh 'docker stop php_app || true'
                    // Perintah 'docker rm' akan menghapus kontainer.
                    // '|| true' memastikan langkah ini tidak menyebabkan build gagal jika kontainer tidak ada.
                    sh 'docker rm php_app || true'
                    // --- AKHIR TAMBAHAN BARU ---

                    // Menjalankan kontainer Docker baru
                    sh 'docker run -d -p 8081:80 --name php_app php-ci-cd'
                }
            }
        }

        // Aksi setelah pipeline selesai (post-build actions)
        post {
            success {
                echo '✅ Build and deployment successful!'
            }
            failure {
                echo '❌ Build failed. Please check the logs.'
            }
            // Opsional: Hentikan dan hapus kontainer setelah build selesai, bahkan jika gagal
            // Ini memastikan lingkungan bersih untuk build berikutnya jika deploy gagal
            always {
                echo 'Cleaning up any running php_app container...'
                sh 'docker stop php_app || true'
                sh 'docker rm php_app || true'
            }
        }
    }
    