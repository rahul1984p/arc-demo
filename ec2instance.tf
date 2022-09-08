module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"
  # insert the 10 required variables here
  name                   = "${var.environment}-arcinstance"
  #instance_count         = 5
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  user_data = <<EOF
#!/bin/bash
sudo yum update -y 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
. ~/.nvm/nvm.sh
nvm install --lts
sudo yum install git
git clone https://github.com/rearc/quest.git
cd quest/
npm install
node src/000.js &&
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
EOF
  tags = local.common_tags
}
