pipeline {

  def image_name = "bash-service"

  stage('Prep') {
    checkout scm
  }

  stage('Build') {
    def image = docker.build("${image_name}:${env.BUILD_ID}")
  }

  stage('Deploy') {
    sh 'docker stop ${image_name} || true'
    sh 'docker run --rm -d -t -p 80:8000 --name ${image_name} ${image_name}:${env.BUILD_ID}'
  }
}