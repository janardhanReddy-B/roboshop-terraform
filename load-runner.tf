data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "Ansible"
  owners           = ["637261222008"]
}

resource "aws_instance" "load-runner" {
  ami                    = data.aws_ami.ami.id
  instance_type          = "t3.medium"
  vpc_security_group_ids = ["sg-0e4bb0aa0db40e4ef"]
  tags = {
    Name = "load-runner"
  }

  provisioner "remote-exec" {
    connection {
      user     = "root"
      password = "DevOps321"
      host     = self.public_ip
    }
    inline = [
      "curl https://raw.githubusercontent.com/linuxautomations/labautomation/master/tools/docker/install.sh | bash",
      "docker pull robotshop/rs-load:latest"
    ]
  }
}