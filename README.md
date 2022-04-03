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
- <info>
-  <info>

---

## How to start
#### Prerequirements:
- terraform
- aws cli
- 1 user

##### Deploy infractraction:

1. Deploy eks:
```sh
cd infra/1_eks_cluster
terraform init
```
2. Configure aws cli on workstation:
```sh
aws configure
```
3. Configure eks on workstation: 
```sh
aws eks update-kubeconfig --region eu-central-1 --name epam_diploma-dev-cluster
```
3. Deploy Jenkins:
```sh
cd infra/2_jenkins/dev
terraform init
```
4. Login and configure Jenkins
```sh
%url%:8080
```