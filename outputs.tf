output "aws_public_address" {
    value = aws_instance.myec2.public_ip
  
}
output "aws_public_dns" {
    value = aws_instance.myec2.public_dns
  
}
output "aws_url_public_address" {
    value = "hhtp://${aws_instance.myec2.public_ip}"
    description = "URL POUR SE CONNECTER à NOTRE SERVEUR NGINX"
  
}