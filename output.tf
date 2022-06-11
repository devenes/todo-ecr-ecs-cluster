output "jenkins-dns-url" {
  value = "http://${aws_instance.jenkins-server.public_ip}:8080"
}

output "ssh-connection" {
  value = "ssh -i ${var.key_pair}.pem ec2-user@${aws_instance.jenkins-server.public_ip}"
}

output "nodejs-url" {
  value = "http://${aws_instance.jenkins-server.public_ip}"
}

output "github-url" {
  value = github_repository.githubrepo.http_clone_url
}

output "aws-account-id" {
  value = data.aws_caller_identity.current.account_id
}
