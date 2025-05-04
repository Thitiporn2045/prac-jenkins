pipeline {
    agent any
    stages {
        stage('list file') {
            steps { 
                sh 'ls -l'
                sh 'ls -l'
            }
        }
        stage('Build Docker Image') {
            steps {
                // สร้าง Docker image
                sh """
                    docker build --rm \
                    -f Dockerfile \
                    -t docker.io/bunyakorngoko/prac-jenkins:latest \
                    -t docker.io/bunyakorngoko/prac-jenkins:${env.BUILD_NUMBER} \
                    .
                """
            }
        }
        stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_CREDENTIALS', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh """
                        echo \$DOCKER_USERNAME
                        echo \$DOCKER_PASSWORD | sed 's/./*/g'
                        docker login -u \$DOCKER_USERNAME -p \$DOCKER_PASSWORD docker.io
                        docker push docker.io/bunyakorngoko/prac-jenkins:${env.BUILD_NUMBER}
                    """
                }
            }
        }
        stage('Deploy to server') {
            steps {
                script {
                    sshagent (credentials: ["SSH_KEY_DEV_SERVER"]){
                        withCredentials([usernamePassword(credentialsId: 'DOCKER_CREDENTIALS', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh """
                                ssh -o StrictHostKeyChecking=no ubuntu@10.11.0.211 '
                                    ls -l
                                    docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD} docker.io
                                    docker pull docker.io/bunyakorngoko/prac-jenkins:${env.BUILD_NUMBER}
                                    docker rm -f jenkins-1
                                    docker run -dp 7001:80 --name jenkins-1 docker.io/bunyakorngoko/prac-jenkins:${env.BUILD_NUMBER}
                                '
                            """
                        }
                    }
                }
            }
        }
    }
}