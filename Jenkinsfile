pipeline {
  environment {
    registry = '502629635618.dkr.ecr.ap-south-1.amazonaws.com/jenkins-cicd'
    registryCredential = 'aws-ecr'
    dockerImage = ''
  }
  agent any
  stages {
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
          echo '$dockerImage'
        }
      }
    }
    stage('Deploy image') {
        steps{
            script{
                docker.withRegistry("https://" + registry, "ecr:ap-south-1:" + registryCredential) {
                    dockerImage.push()
                }
            }
        }
    }
    
    stage('test AWS credentials') {
            steps {
                withAWS(credentials: 'aws-ecr', region: 'ap-south-1') {
                  sh "chmod +x ./jenkins_ecr.sh"
                  sh "./jenkins_ecr.sh"
                }
            }
        }
    }
}