output "url-jenkins" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "public_ip" {
  value = aws_instance.jenkins.public_ip
}
