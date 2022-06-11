<div align="center" id="top"> 
  <!-- <img src="./.github/app.gif" alt="Todo Web App" /> -->

  <!-- &#xa0; -->

  <!-- <a href="https://todowebapp.netlify.app">Demo</a> -->
</div>

<h1 align="center">Todo Web Application Deployed on ECR to ECS Cluster with Jenkins Pipeline</h1>

<p align="center">
  <a href="https://github.com/devenes/todo-ecr-ecs-cluster/actions/workflows/node.js.yml"> <img src="https://github.com/devenes/todo-ecr-ecs-cluster/actions/workflows/node.js.yml/badge.svg" alt="Test"/></a>
  <img alt="Tool" src="https://shields.io/badge/-Terraform-%235835CC?logo=terraform&style=Flat">
  <img alt="Tool" src="https://badges.aleen42.com/src/docker.svg">
  <img alt="Tool" src="https://badges.aleen42.com/src/node.svg">
  <img alt="Tool" src="https://badges.aleen42.com/src/javascript.svg">
  <img alt="Tool" src="https://badges.aleen42.com/src/react.svg">
  <img alt="Tool" src="https://badges.aleen42.com/src/github.svg">
  <img alt="Github top language" src="https://img.shields.io/github/languages/top/devenes/todo-ecr-ecs-cluster?color=red">
  <img alt="Github language count" src="https://img.shields.io/github/languages/count/devenes/todo-ecr-ecs-cluster?color=purple">
  <img alt="Repository size" src="https://img.shields.io/github/repo-size/devenes/todo-ecr-ecs-cluster?color=green">
  <img alt="License" src="https://img.shields.io/github/license/devenes/todo-ecr-ecs-cluster?color=brown">  
  <img alt="Github stars" src="https://img.shields.io/github/stars/devenes/todo-ecr-ecs-cluster?color=56BEB8" /> 
  <!-- <img alt="Github issues" src="https://img.shields.io/github/issues/devenes/todo-ecr-ecs-cluster?color=56BEB8" />
  <img alt="Github forks" src="https://img.shields.io/github/forks/devenes/todo-ecr-ecs-cluster?color=56BEB8" />-->  
</p>

<!-- Status -->

<!-- <h4 align="center"> 
	🚧  Todo Web App 🚀 Under construction...  🚧
</h4> 

<hr> -->

<p align="center">
  <a href="#dart-about">About</a> &#xa0; | &#xa0; 
  <a href="#rocket-technologies">Technologies</a> &#xa0; | &#xa0;
  <a href="#white_check_mark-requirements">Requirements</a> &#xa0; | &#xa0;
  <a href="#checkered_flag-starting">Starting</a> &#xa0; | &#xa0;
  <a href="#-Expected-Output">Output</a> &#xa0; | &#xa0;
  <a href="#memo-license">License</a> &#xa0; | &#xa0;
  <a href="https://github.com/devenes" target="_blank">Author</a>
</p>

## :dart: About ##

Javascript web application 🚀 automated with Jenkins pipeline to create Docker image and push the image to AWS Elastic Container Registry (ECR) and deploy them on Elastic Container Service (ECS) Cluster.

## :rocket: Technologies ##

The following tools were used in this project:

- [Node.js](https://nodejs.org/en/)
- [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
- [CSS](https://developer.mozilla.org/en-US/docs/Web/CSS)
- [HTML](https://developer.mozilla.org/en-US/docs/Web/HTML)
- [Docker](https://www.docker.com/)
- [Git](https://git-scm.com/)
- [GitHub](https://github.com/)
- [Yarn](https://yarnpkg.com/)
- [React](https://reactjs.org/)
- [Express](https://expressjs.com/)
- [SQLite](https://www.sqlite.org/)
- [Terraform](https://www.terraform.io/)
- [Jenkins](https://jenkins.io/)

## :white_check_mark: Requirements ##

Before starting :checkered_flag: you need to have [Git](https://git-scm.com), [Docker](https://www.docker.com/), [Yarn](https://yarnpkg.com/) and [Node](https://nodejs.org/en/) installed.

## :checkered_flag: Starting ##

### If you want to start the project locally, you can use the following commands:

```bash
# Clone this project
git clone https://github.com/devenes/todo-ecr-ecs-cluster
```

```bash
# Access
cd todo-ecr-ecs-cluster
```

```bash
# Install dependencies
yarn install --production
```

```bash
# Run the project
# The server will initialize in the <http://localhost:3000>
npm run start
```

### You can run Terraform commands in the project folder:

```bash
# Run the Terraform init command
terraform init
```

```bash
# Run the Terraform plan command
terraform plan
# After this command, you will see the changes that will be applied to the infrastructure
# You can run the apply command to apply the changes
terraform apply --auto-approve
```

- if you want to manually run 

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com
```

- Then run the image

```bash
docker run --name todo -dp 80:3000 <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/devenes/to-do-app:latest
```
- Delete the container 

```bash
docker container stop todo
docker container rm todo
```

- Createa ECS cluster with a unique name with the following command.

```bash
aws ecs create-cluster --cluster-name to-do-app
```

- Register the task definition with the following command.

```bash
aws ecs register-task-definition --cli-input-json file://to-do-app.json
```

- List the task definitions.

```bash
aws ecs list-task-definitions
```

- Create a service with following command.
> Note: securityGroups=[sg-e29b36ce] is default security group. If we don't specify any security group, aws assign default security group to the cluster.
```bash
# change the subnets and security group and make sure that the 3000 port is open
aws ecs create-service --cluster to-do-app --service-name to-do-app-service --task-definition to-do-app --desired-count 1 --launch-type "FARGATE" --network-configuration "awsvpcConfiguration={subnets=[subnet-077c9758],securityGroups=[sg-e29b36ce],assignPublicIp=ENABLED}" 
```

### If you want to run the project in a Docker container, you can use the following command:

- Build the Docker container image using the `docker build` command.

```bash
docker build -t todo-app:v1.0 .
```

- Show the Docker image is created successfully.

```bash
docker image ls
```

- Run `todo app` from the local Docker image.

```bash
docker run --name todo -d -p 80:3000 todo-app:v1.0
# The server will initialize in the <http://localhost:80>
```

- List running container.

```bash
docker ps
# or
docker container ls
```
- If necessary, authenticate the Docker CLI to your default `ECR registry`.

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com
```

- Delete the ECR repository `devenes-repo/todo-app` from AWS CLI.

```bash
aws ecr delete-repository \
      --repository-name devenes/to-do-app \
      --force \
      --region us-east-1
```

- Delete the service and ecs cluster.

```bash
aws ecs delete-service --cluster to-do-app --service to-do-app-service --force
aws ecs delete-cluster --cluster to-do-app
```

## 📷 Expected Output ##

![output](output.jpg)

## 📚 Resources

- [Node.js Documentation](https://nodejs.org/en/docs/)

- [GitHub Documentation](https://docs.github.com/en/get-started/)

- [Docker Documentation](https://docs.docker.com/get-started/overview/)

## :memo: License ##

This project is under license from Apache. For more details, see the [LICENSE](LICENSE) file.


Made with :heart: by <a href="https://github.com/devenes" target="_blank">devenes</a>

&#xa0;

<a href="#top">⬆️ Back to top</a>
