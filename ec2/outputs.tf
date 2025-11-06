output "public_ip" {
  description = "Public IP of the provisioned EC2"
  value       = aws_instance.tf_tut_instance.public_ip
}
