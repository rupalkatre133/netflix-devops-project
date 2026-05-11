pipeline {

    agent any

    environment {

        IMAGE_NAME = "rupalkatre/netflix-clone"
    }

    stages {

        stage('Clone Repository') {

            steps {

                git 'https://github.com/rupalkatre133/netflix-devops-project.git'
            }
        }

        stage('Build Docker Image') {

            steps {

                sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'
            }
        }

        stage('Docker Login') {

            steps {

                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'USERNAME',
                    passwordVariable: 'PASSWORD'
                )]) {

                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {

            steps {

                sh 'docker push $IMAGE_NAME:$BUILD_NUMBER'
            }
        }

        stage('Terraform Init') {

            steps {

                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {

                    dir('terraform') {

                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Apply') {

            steps {

                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {

                    dir('terraform') {

                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Configure Kubernetes') {

            steps {

                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {

                    sh '''
                    aws eks update-kubeconfig \
                    --region us-east-1 \
                    --name netflix-eks-cluster
                    '''
                }
            }
        }

        stage('Deploy Kubernetes') {

            steps {

                sh 'kubectl apply -f kubernetes/'
            }
        }
    }

    post {

        success {

            echo 'Pipeline Successfully Completed'
        }

        failure {

            echo 'Pipeline Failed'
        }
    }
}
