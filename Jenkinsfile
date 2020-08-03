def image_name = "bash-service"

node {
    stage('Prep') {
      echo "Some change"
      checkout scm
    }

    stage('Build') {
      docker {
        def image = docker.build("${image_name}:${env.BUILD_ID}")
      }
    }

    stage('Deploy') {
      sh 'docker stop ${image_name} || true'
      sh 'docker run --rm -d -t -p 80:8000 --name ${image_name} ${image_name}:${env.BUILD_ID}'
    }
}