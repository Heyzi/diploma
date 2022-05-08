![dev_back](https://github.com/heyzi/diploma/actions/workflows/dev_back_ci.yml/badge.svg) ![prod_back](https://github.com/heyzi/diploma/actions/workflows/prod_back_configuration.yml/badge.svg)

![dev_front](https://github.com/heyzi/diploma/actions/workflows/dev_front_ci.yml/badge.svg) ![prod_front](https://github.com/heyzi/diploma/actions/workflows/prod_front_configuration.yml/badge.svg)

---
#  [24 stream] EPAM diploma

## Variant 7
Using API https://www.metaweather.com/api/ get data about weather in Moscow for current month and store it into your DB: id, weather_state_name, wind_direction_compass, created, applicable_date, min_temp, max_temp, the_temp. Output the data by date (the date is set) in form of a table and sort them by created in ascending order.

- Push
- Wait
- ✨Suffer✨

---

## Main information

- THE SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY WARRANTY. THE DEVELOPER IS NOT RESPONSIBLE FOR ANY SUFFERING, THERMONUCLEAR WAR, OR THE CURRENT ECONOMIC CRISIS CAUSED BY YOU FOLLOWING THESE DIRECTIONS. GOOD LUCK!
- Dockerfile validated in [hadolint](https://github.com/hadolint/hadolint)
- Code scanned by Sonar Cloud

---

## How to start
#### Prerequirements:
- [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Kustomize](https://kubectl.docs.kubernetes.io/installation/kustomize/)
- [argocd](https://argo-cd.readthedocs.io/en/stable/cli_installation/)

### Preparation:
1. Provide AWS Credentials 

```sh
aws configure
```

2. Create s3 bucket
```sh
aws s3 mb s3://%BUCKET_NAME% --region %REGION_NAME%
```

3. Replace s3 bucket in infra/01_eks_cluster/backend.tf

4. Create ECR repo

```sh
aws ecr create-repository  --repository-name frontend-diploma
aws ecr create-repository  --repository-name backend-diploma
```

5. Replace ECR repo names(if name changed) in .github/workflows/*
ECR_REPOSITORY

6. Configure secrets in github action:

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- MY_AWS_REGION
- SONAR_TOKEN

7. Configure sonarcloud
https://github.com/SonarSource/sonarcloud-github-action

8. Launch workflow for building first images

---

### Initialization:
1. Deploy cluster and database (~15 min):
```sh
terraform -chdir=infra/01_eks_cluster init
terraform -chdir=infra/01_eks_cluster plan
terraform -chdir=infra/01_eks_cluster apply -auto-approve
```

> _Due to bugs found in the deployed cluster via terraform, it is better to deploy the cluster via eksctl:_

> eksctl create cluster -f infra/02_eksctl/cluster.yaml

>_And deploy the base by hand (don't forget about security groups)_


2. Launch initialization script (~3 min):
```sh
Fullfill DB information:
env_dev
env_prod

./diploma_init.sh
```
#### Variables in **env_dev** and **env_prod**:

**DBHOST=** - database endpoint

**DBUSER=-** databse instance user

**DBPASSWD=** - databse instance user password

**DB_NAME=** - any name, db will be created at app launch

3. At the end of the run this script, we get this inforamtion:

- "DEV Application url:" %url%
- "PROD Application url:" %url%
- "Grafana URL:" "http://localhost:3000/"
- "ARGOCD URL:" "http://localhost:8080/"
- "ARGOCD PASSWD:" %passwd%

---

### CD
1. Configure argocd
- http://localhost:8080/

2. ✨Suffer again✨

---
### Usefull staff:

- Scaller logs:
```
kubectl -n kube-system logs -f deployment/cluster-autoscaler
```
- Total pods count:
```
kubectl get po -A --no-headers | wc -l
```