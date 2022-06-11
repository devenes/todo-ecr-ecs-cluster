# This terraform file creates a Jenkins Server using JDK 11 on EC2 Instance.
# Jenkins Server is enabled with Git, Docker and Docker Compose,
# AWS CLI Version 2. Jenkins Server will run on Amazon Linux 2 EC2 Instance with
# custom security group allowing HTTP(80, 8080) and SSH (22) connections from anywhere. 
# Jenkins Server will be accessible from the public IP address of the EC2 Instance.

resource "github_repository" "githubrepo" {
  name       = var.github_repository_name
  visibility = var.github_repository_visibility
}

resource "aws_security_group" "ec2-sec-gr" {
  name = var.security_group
  tags = {
    Name = var.security_group
  }
  dynamic "ingress" {
    for_each = var.sg-ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "roleforjenkins" {
  name                = var.jenkins_iam_role_name
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AdministratorAccess", "arn:aws:iam::aws:policy/AmazonECS_FullAccess"]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.ec2_profile_name
  role = aws_iam_role.roleforjenkins.name
}

resource "aws_instance" "jenkins-server" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_pair
  root_block_device {
    volume_size = var.ec2_volume_size
  }
  security_groups = [aws_security_group.ec2-sec-gr.name]
  tags = {
    Name = var.server_name
  }
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data            = <<-EOF
          #! /bin/bash
          # install git
          yum install git -y
          # update os
          yum update -y
          # set server hostname as Jenkins-Server
          hostnamectl set-hostname "Jenkins-Server"
          # install java 11
          amazon-linux-extras install java-openjdk11 -y
          wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
          rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
          amazon-linux-extras install epel
          # install jenkins
          yum install jenkins -y
          systemctl start jenkins
          systemctl enable jenkins
          # install docker
          amazon-linux-extras install docker -y
          systemctl start docker
          systemctl enable docker
          # add ec2-user and jenkins users to docker group 
          usermod -a -G docker ec2-user
          usermod -a -G docker jenkins
          # configure docker as cloud agent for jenkins
          cp /lib/systemd/system/docker.service /lib/systemd/system/docker.service.bak
          sed -i 's/^ExecStart=.*/ExecStart=\/usr\/bin\/dockerd -H tcp:\/\/127.0.0.1:2375 -H unix:\/\/\/var\/run\/docker.sock/g' /lib/systemd/system/docker.service
          # systemctl daemon-reload
          systemctl restart docker
          systemctl restart jenkins
          # uninstall aws cli version 1
          rm -rf /bin/aws
          # install aws cli version 2
          curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
          unzip awscliv2.zip
          ./aws/install
          EOF

  provisioner "remote-exec" {
    inline = [
      "sleep 150",
      "wget https://github.com/devenes/todo-ecr-ecs-cluster/raw/master/to-do-app-nodejs.tar",
      "tar -xvf to-do-app-nodejs.tar",
      "rm to-do-app-nodejs.tar",
      "git clone https://${var.github-username}:${var.github-token}@github.com/${var.github-username}/${github_repository.githubrepo.name}.git",
      "cd todo-app-node-project",
      "cp -R /home/ec2-user/to-do-app-nodejs/* /home/ec2-user/todo-app-node-project/",
      "git config --global user.email ${var.github-email}",
      "git config --global user.name ${var.github-username}",
      "git add .",
      "git commit -m 'added todo app'",
      "git push https://${var.github-username}:${var.github-token}@github.com/${var.github-username}/${github_repository.githubrepo.name}",
    ]
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file("${var.pem_key_address}")
      host        = self.public_ip
    }
  }
}
