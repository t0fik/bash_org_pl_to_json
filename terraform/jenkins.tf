resource "aws_instance" "jenkins" {
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  ami                         = "ami-0c115dbd34c69a004"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids = [
    module.sg.this_security_group_id,
    module.vpc.default_security_group_id
  ]

  key_name = var.key_name

  tags = {
    Name = "jenkins"
  }

  provisioner "remote-exec" {
    inline = ["sudo yum -y install python"]
  }


  connection {
    host = self.public_ip
    private_key = file(var.private_key)
    user = var.user_name
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ${var.user_name} --private-key ${var.private_key} -i '${self.public_ dns},' playbooks/install_jenkins.yaml"
  }

}