pipeline {

  agent any
  stages {
    stage('Building image') {
      when {
        (env_type=='create')
      }
      steps{
        script {
          dockerImage = docker.build registry + ":latest"
          sh 'echo $dockerImage'
        }
      }  
  }
  stage('Create ECR repo in AWS') {
    when {
        (env_type=='create')
      }
      steps {
          withAWS(credentials: 'aws-ecr', region: 'ap-south-1') {
            script{
              aws ecr create-repository \
--repository-name jenkins-cicd
            }
          }
      } 
    }

    stage('Push Image to AWS ECR') {
      when {
        (env_type=='create')
      }
      steps{
          script{
              docker.withRegistry("https://" + registry, "ecr:ap-south-1:" + registryCredential) {
                  dockerImage.push()
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