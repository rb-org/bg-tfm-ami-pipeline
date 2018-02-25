// Security Group Resource for Module
resource "aws_security_group" "sg_pckr" {
  name        = "${var.name_prefix}-sg-pckr"
  description = "Security Group ${var.name_prefix}-sg-pckr"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.default_tags, 
    map("Environment", format("%s", var.environment)), 
    map("Workspace", format("%s", terraform.workspace)),
    map("Name", format("%s-sg-pckr", var.name_prefix))
    )
  }"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// allow traffic for TCP 22 (SSH)
resource "aws_security_group_rule" "allow_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]

  #prefix_list_ids = ["pl-12c4e678"]  
  security_group_id = "${aws_security_group.sg_pckr.id}"

  #source_security_group_id = "${var.source_sg_id_ssh}"
}

// allow traffic for TCP 22 (SSH)
resource "aws_security_group_rule" "allow_winrm" {
  type      = "ingress"
  from_port = 5985
  to_port   = 5986
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]

  #prefix_list_ids = ["pl-12c4e678"]  
  security_group_id = "${aws_security_group.sg_pckr.id}"

  #source_security_group_id = "${var.source_sg_id_ssh}"
}
