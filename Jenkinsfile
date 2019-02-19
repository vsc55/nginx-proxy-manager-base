pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    disableConcurrentBuilds()
  }
  agent any
  environment {
    IMAGE            = "nginx-proxy-manager-base"
    TEMP_IMAGE       = "nginx-proxy-manager-base-build_${BUILD_NUMBER}"
    TEMP_IMAGE_ARM   = "nginx-proxy-manager-base-arm-build_${BUILD_NUMBER}"
    TEMP_IMAGE_ARM64 = "nginx-proxy-manager-base-arm64-build_${BUILD_NUMBER}"
  }
  stages {
    stage('Build') {
      parallel {
        stage('x86_64') {
          steps {
            sh 'docker build --pull --no-cache --squash --compress -t $TEMP_IMAGE .'
            sh 'docker tag $TEMP_IMAGE $DOCKER_PRIVATE_REGISTRY/$IMAGE:latest'
            sh 'docker push $DOCKER_PRIVATE_REGISTRY/$IMAGE:latest'
            sh 'docker tag $TEMP_IMAGE docker.io/jc21/$IMAGE:latest'

            withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
              sh "docker login -u '${duser}' -p '$dpass'"
              sh 'docker push docker.io/jc21/$IMAGE:latest'
            }

            sh 'docker rmi $TEMP_IMAGE'
          }
        }
        stage('armhf') {
          agent {
            label 'armhf'
          }
          steps {
            sh 'docker build --pull --no-cache --squash --compress -f Dockerfile.armhf -t $TEMP_IMAGE_ARM .'
            sh 'docker tag $TEMP_IMAGE_ARM $DOCKER_PRIVATE_REGISTRY/$IMAGE:armhf'
            sh 'docker push $DOCKER_PRIVATE_REGISTRY/$IMAGE:armhf'
            sh 'docker tag $TEMP_IMAGE_ARM docker.io/jc21/$IMAGE:armhf'

            withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
              sh "docker login -u '${duser}' -p '$dpass'"
              sh 'docker push docker.io/jc21/$IMAGE:armhf'
            }

            sh 'docker rmi $TEMP_IMAGE_ARM'
          }
        }
        stage('arm64') {
          agent {
            label 'arm64'
          }
          steps {
            sh 'docker build --pull --no-cache --squash --compress -f Dockerfile.arm64 -t $TEMP_IMAGE_ARM64 .'
            sh 'docker tag $TEMP_IMAGE_ARM64 $DOCKER_PRIVATE_REGISTRY/$IMAGE:arm64'
            sh 'docker push $DOCKER_PRIVATE_REGISTRY/$IMAGE:arm64'
            sh 'docker tag $TEMP_IMAGE_ARM64 docker.io/jc21/$IMAGE:arm64'

            withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
              sh "docker login -u '${duser}' -p '$dpass'"
              sh 'docker push docker.io/jc21/$IMAGE:arm64'
            }

            sh 'docker rmi $TEMP_IMAGE_ARM64'
          }
        }
      }
    }
  }
  triggers {
    bitbucketPush()
  }
  post {
    success {
      juxtapose event: 'success'
      sh 'figlet "SUCCESS"'
    }
    failure {
      juxtapose event: 'failure'
      sh 'figlet "FAILURE"'
    }
  }
}
