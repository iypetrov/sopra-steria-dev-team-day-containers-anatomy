resource "aws_iam_role" "vm_role" {
  name = "vm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vm_role_policy_attachment" {
  role       = aws_iam_role.vm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "vm_profile" {
  name = "vm-profile"
  role = aws_iam_role.vm_role.name
}

resource "aws_instance" "vm_one" {
  ami                         = "ami-0a628e1e89aaedf80"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_subnet_a.id
  vpc_security_group_ids      = [aws_security_group.vm_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.vm_profile.name
  user_data_replace_on_change = true
  user_data = <<-EOF
  #!/usr/bin/env bash

  set -euxo pipefail

  adduser --disabled-password --gecos "" sopra
  echo 'sopra ALL=(ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/sopra
  chmod 440 /etc/sudoers.d/sopra

  echo "export PS1='\[\e[1;32m\]sopra@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]# '" >> /home/sopra/.bashrc
  chown sopra:sopra /home/sopra/.bashrc

  apt-get update -y
  apt-get install -y git curl vim tmux stow python3 python3-pip python3.12-venv
  ln -sf /usr/bin/python3 /usr/bin/python

  mkdir /projects
  chown sopra:sopra /projects

  runuser -l sopra -c "
    set -eux
    git config --global user.email "ilia.petrov@soprasteria.com"
    git config --global user.name "iypetrov"

    git clone https://github.com/iypetrov/.vm-dotfiles.git
    cp .vm-dotfiles/.vimrc-personal .vimrc
    cp .vm-dotfiles/.tmux.conf .tmux.conf

    git clone https://iypetrov:${var.github_access_token}@github.com/iypetrov/sopra-steria-dev-team-day-containers-anatomy.git /projects/sopra-steria-dev-team-day-containers-anatomy
  "
  EOF
tags = {
    Name = "sopra-steria-dev-team-day-containers-anatomy"
  }
}
