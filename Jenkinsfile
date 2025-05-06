pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                // สร้าง Docker image
                sh """
                    docker build --rm \
                    -f Dockerfile \
                    -t docker.io/thitiporn2045/jenkins-oddscloud \
                    -t docker.io/thitiporn2045/jenkins-oddscloud:${env.BUILD_NUMBER} \
                    .
                """
            }
        }
        stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_CREDENTIALS_GIFT', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh """
                        echo $DOCKER_USERNAME
                        # เข้าสู่ Docker registry
                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD docker.io
                        
                        # Push Docker image ไปที่ DockerHub
                        docker push docker.io/thitiporn2045/jenkins-oddscloud:${env.BUILD_NUMBER}
                    """
                }
            }
        }
        stage('Deploy to server') {
            steps {
                script {
                    sshagent(credentials: ["SSH_KEY_DEV_SERVER_GIFT"]) {
                        withCredentials([usernamePassword(credentialsId: 'DOCKER_CREDENTIALS_GIFT', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh """
                                # Login to Docker registry บน server
                                ssh -o StrictHostKeyChecking=no -l ubuntu 10.11.0.211 \"
                                    docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD registry-1.docker.io
                                    
                                    # Pull Docker image ที่อัพโหลดจาก Jenkins
                                    docker pull registry-1.docker.io/thitiporn2045/jenkins-oddscloud:${env.BUILD_NUMBER}
                                    
                                    # Run Docker container บน server
                                    docker run -dp 7002:80 registry-1.docker.io/thitiporn2045/jenkins-oddscloud:${env.BUILD_NUMBER}
                                \"
                            """
                        }
                    }
                }
            }
        }
    }
}
