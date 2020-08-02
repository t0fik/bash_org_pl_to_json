output "url-jenkins" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "public-ip" {
  value = aws_instance.jenkins.public_ip
}

output "initialAdminPassword" {
  value = fileexists("/tmp/${aws_instance.jenkins.id}/initialAdminPassword") ? file("/tmp/${aws_instance.jenkins.id}/initialAdminPassword") : ""
}