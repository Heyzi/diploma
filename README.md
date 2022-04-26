#  [24 stream] EPAM diploma

---

## Variant 7
Using API https://www.metaweather.com/api/ get data about weather in Moscow for current month and store it into your DB: id, weather_state_name, wind_direction_compass, created, applicable_date, min_temp, max_temp, the_temp. Output the data by date (the date is set) in form of a table and sort them by created in ascending order.

- Push
- Wait
- ✨Suffer✨

---

## Main information

- Dockerfile validated in [hadolint](https://github.com/hadolint/hadolint)
- Code scanned by Sonar Cloud
- Github 
- Something else was made

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

2. Replace repo in k8s dir
3. Launch workflow for building images

---

### Initialization:
1. Deploy cluster and database (~12 min):
```sh
terraform -chdir=infra/00_cluster init
terraform -chdir=infra/00_cluster plan
terraform -chdir=infra/00_cluster apply -auto-approve
```

2. Launch initialization script (~3 min):
```sh
./diploma_init.sh
```
3. At the end of the run this script, we get this inforamtion:

- "DEV Application url:" %url%
- "PROD Application url:" %url%
- "Grafana URL:" "http://localhost:3000/"
- "ARGOCD URL:" "http://localhost:8080/"
- "ARGOCD PASSWD:" %passwd%

---

### CI\CD
1. Configure secrets:

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- MY_AWS_REGION
- SONAR_TOKEN

2. Configure sonarcloud
https://github.com/SonarSource/sonarcloud-github-action

3. Configure argocd
- http://localhost:8080/

4. ✨Suffer✨
