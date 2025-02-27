# Output the public IPs of the instances
output "instance_public_ips" {
  value = aws_instance.stock_server.*.public_ip
}

# Output the private IPs of the instances
output "instance_private_ips" {
  value = aws_instance.stock_server.*.private_ip
}