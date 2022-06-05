pipeline {
  environment {
    registryCredential = 'aws-ecr'
  }
  agent any
  stages {
    stage('Create ECR repo in AWS') {
          steps {
              withAWS(credentials: 'aws-ecr', region: 'ap-south-1') {
                script{
                  if (env_type=='create'){
                    sh 'aws ecr create-repository \
    --repository-name $image_name'
                }
              }
          } 
      }
    }

    stage('replacing aws account id in docker-compose file') {
          steps {
              withAWS(credentials: 'aws-ecr', region: 'ap-south-1') {
                script{
                  if (env_type=='create'){
                sh  '''
                    sed -i "s;accid;$accid;" docker-compose.yml
                    echo $accid
                    
                    '''
                }
              }
          } 
      }
    }
    stage('Building image') {
      steps{
        script {
          if (env_type=='create'){
            app = docker.build("$image_name")
          }
      }
    }
    }
    stage('Push Image to AWS ECR') {
        steps{
          withAWS(credentials: 'aws-ecr', region: 'ap-south-1'){
            script{
              if (env_type=='create'){
                docker.withRegistry("https://$accid", "ecr:ap-south-1:" + registryCredential) {
                app.push("$image_tag")
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
