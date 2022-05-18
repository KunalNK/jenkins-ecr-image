pipeline {
  environment {
    registry = '349443600135.dkr.ecr.ap-south-1.amazonaws.com/jenkins-cicd'
    registryCredential = 'aws-ecr'
    // dockerImage = ''
  }
  agent any
  stages {
    stage('Create ECR repo in AWS') {
          steps {
              withAWS(credentials: 'aws-ecr', region: 'ap-south-1') {
                script{
                  if (env_type=='create'){
                    sh 'aws ecr create-repository \
    --repository-name jenkins-cicd'
                }
              }
          } 
      }
    }
    stage('Building image') {
      steps{
        script {
          if (env_type=='create'){
          dockerImage = docker.build registry + ":latest"
          sh 'echo $dockerImage'
        }
      }
    }
    }
    stage('Push Image to AWS ECR') {
        steps{
          withAWS(credentials: 'aws-ecr', region: 'ap-south-1'){
            script{
              if (env_type=='create'){
                docker.withRegistry("https://" + registry, "ecr:ap-south-1:" + registryCredential) {
                dockerImage.push()
                }
            }
        }
    }
    }
    }
    
    
    stage('Deploy docker image to AWS ECS container') {
            steps {
                withAWS(credentials: 'aws-ecr', region: 'ap-south-1') {
                  script{
                  if (env_type=='create'){
                    sh "chmod +x ./create_cluster.sh"
                    sh "./create_cluster.sh"
                  }
                  else {
                    sh "chmod +x ./delete_cluster.sh"
                    sh "./delete_cluster.sh"
                  }
                  }
                }
            }
        }
    }
}