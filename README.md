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
- [helm](https://helm.sh/docs/intro/install/)

#### Preparation:
1. Create ECR repo
2. Replace repo in k8s dir
3. Launch workflow for building images

#### Initialization:
1. Deploy eks cluster:
```sh
cd infra/0_eks_cluster
terraform init
```
2. Launch initialization script:
```sh
./diploma_init.sh
```
3. At the end of the run, we get two links to the pro- and dev-versions of the application

### CI\CD
1. Configure secrets
2. Configure sonar