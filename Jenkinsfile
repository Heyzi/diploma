node {
    def Namespace = "default"
    def ImageName = "helloworld.k8s.java.repo"
    def ECRLink = "https://112312.dkr.ecr.ap-southeast-2.amazonaws.com"

stage('Checkout'){
      git 'https://github.com/Heyzi/diploma.git'
      sh "git rev-parse --short HEAD > .git/commit-id"
      imageTag= readFile('.git/commit-id').trim()
}

stage('Docker Build and Push'){
        dir("${env.WORKSPACE}"){
            docker.build("${ImageName}:latest")
        }
            
        docker.withRegistry("${ECRLink}", 'ecr:ap-southeast-2:helloworld-ecr'){
            docker.image("${ImageName}").push("${ImageTag}")
        }
     }

stage('Deploy helloworld on K8s'){
        dir("${env.WORKSPACE}"){
            sh "ansible-playbook ./cicd/k8s_app_deploy.yml  --extra-vars ECRLink=${ECRLink}  --extra-vars ImageName=${ImageName} --extra-vars imageTag=${ImageTag} --extra-vars Namespace=${Namespace}"
        }
    }
}