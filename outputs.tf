output "public_ssh_security_group_id" {
  description = "Public SSH Security Group ID"
  value       = "${aws_security_group.public_ssh_security_group.id}"
}

output "private_ssh_security_group_id" {
  description = "Private SSH Security Group ID"
  value       = "${aws_security_group.private_ssh_security_group.id}"
}

output "public_web_security_group_id" {
  description = "Public Web Security Group ID"
  value       = "${aws_security_group.public_web_security_group.id}"
}

output "private_web_security_group_id" {
  description = "Private Web Security Group ID"
  value       = "${aws_security_group.private_web_security_group.id}"
}
