node {
    def Namespace = "prod"
    def ImageName = "backend"
    def ECRLink = "035604165710.dkr.ecr.eu-central-1.amazonaws.com/epam_diploma"
    def Appdir = "app/backend"

 stage ('checkout'){
        final scmVars = checkout(scm)
        ImageTag = "${checkout(scm).GIT_COMMIT}"
    }

stage('Docker Build and Push'){
        dir("${Appdir}"){
            docker.build("${ImageName}:latest")
        }
           
        docker.withRegistry("https://" + "${ECRLink}", "ecr:eu-central-1:"){
            docker.image("${ImageName}").push("${ImageTag}")
        }
     }

stage('Deploy helloworld on K8s'){
        dir("${Appdir}"){
            sh "ansible-playbook ./cicd/k8s_app_deploy.yml  --extra-vars ECRLink=${ECRLink}  --extra-vars ImageName=${ImageName} --extra-vars imageTag=${ImageTag} --extra-vars Namespace=${Namespace}"
        }
    }
}