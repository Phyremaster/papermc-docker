
pipeline {
  agent {
    kubernetes {
        yaml '''
            apiVersion: v1
            kind: Pod
            metadata:
                name: build
            spec:
                volumes:
                - name: kaniko-config
                  secret:
                    secretName: kaniko-config
                containers:
                    - name: kaniko
                      image: gcr.io/kaniko-project/executor:debug
                      imagePullPolicy: "IfNotPresent"
                      command:
                        - /busybox/cat
                      tty: true
                      volumeMounts:
                        - mountPath: "/kaniko/.docker/config.json"
                          subPath: "config.json"
                          readOnly: true
                          name: kaniko-config
        '''
    }
  }
  
  stages {
    stage('Build/Push Docker Image') {
      steps {
        container('kaniko') {
            sh "/kaniko/executor --context . --cache --destination=enigodupont/papermc-docker:latest --destination=enigodupont/papermc-docker:$BUILD_NUMBER"
        }
      }
    }
  }
}
