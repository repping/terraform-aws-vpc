output "vpc_id" {
  value = aws_vpc.main.id
}
output "vpc_public_subnet" {
  value = aws_subnet.public.id
}
output "vpc_private_subnet" {
  value = aws_subnet.private.id
}
output "vpc_db_subnet_group" {
  value = aws_db_subnet_group.default.id
}