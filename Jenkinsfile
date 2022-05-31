node {
  def MVN_HOME
  stage('init') {
    echo "Current workspace : ${WORKSPACE}"
    MVN_HOME = tool 'maven 3.8.5'
  }
  stage('project-clone'){
    git 'https://github.com/jimmy3663/reqres_products'
}
  stage('project-build'){
    sh "'${MVN_HOME}/bin/mvn' package"
  }
stage('deploy'){
    fileOperations([
      // 배포 디렉토리 삭제
      folderDeleteOperation('target/deploy'),
      // 배포 디렉토리 생성
      folderCreateOperation('target/deploy'),
      // CodeDeploy 에서 사용할 scripts 디렉토리 복사 
      fileCopyOperation(excludes: '', flattenFiles: false, includes: 'start_server.sh', targetLocation: 'target/deploy'),
      fileCopyOperation(excludes: '', flattenFiles: false, includes: 'stop_server.sh', targetLocation: 'target/deploy'),
      
      // 빌드된 Application 의 결과물 복사
      fileCopyOperation(excludes: '', flattenFiles: true, includes: 'target/*SNAPSHOT.jar', targetLocation: 'target/deploy'),
      
      // CodeDeploy 에서 사용할 appspec 파일 복사
      fileCopyOperation(excludes: '', flattenFiles: true, includes: 'appspec.yml', targetLocation: 'target/deploy')
    ])
    dir("./target/deploy"){
      withCredentials([[$class:    'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: "${awsCredentialId}",  secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
      step([$class: 'AWSCodeDeployPublisher',
        // CodeDeploy Application 명
        applicationName: 'ljs-deploy',
        // AWS Credentials Access Key ID
        awsAccessKey: "${AWS_ACCESS_KEY_ID}",
        // AWS Credentials Secret Key
        awsSecretKey: "${AWS_SECRET_ACCESS_KEY}",
        credentials: 'awsAccessKey',
        // CodeDeploy 배포그룹에 명시된 배포 방식 유형
        deploymentConfig: 'CodeDeployDefault.OneAtATime',
        deploymentGroupAppspec: false,
        // CodeDeploy 배포그룹명
        deploymentGroupName: 'ljs-springboot-deploy-grp',
        excludes: '',
        iamRoleArn: 'arn:aws:iam::815854164176:role/ljs-codedeploy',
        // 배포 어플리케이션의 Artifact 위치
        includes: '**',
        proxyHost: '',
        proxyPort: 0,
        // Region 명
        region: 'eu-west-3',
        // Archive 될 S3 Bucket 명
        s3bucket: 'ljs-s3-bucket',
        // Archive 될 S3 Bucket 경로
        s3prefix: "deploy",
        subdirectory: '',
            versionFileName: '${BUILD_NUMBER}',
        // CodeDeploy 가 수행 완료 될때 까지의 대기여부 설정
        waitForCompletion: true,
        // CodeDeploy 가 수행 완료 될때 까지의 Timeout
        pollingTimeoutSec: 1800
      ])
    }
  }
}
}
