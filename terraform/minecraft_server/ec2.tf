resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_minecraft" {
  name        = "allow_minecraft"
  description = "Allow Minecraft inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "minecraft" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance_type
  security_groups = [
    aws_security_group.allow_ssh.name, 
    aws_security_group.allow_minecraft.name
  ]
  key_name = var.key_pair
  user_data = data.template_file.minecraft_server_init_script.rendered
  iam_instance_profile = aws_iam_instance_profile.ccg_minecraft_implicit_instance_profile.name

  root_block_device {
    volume_size = 64
  }
  
  tags = {
    Name = "minecraft"
  }
}

