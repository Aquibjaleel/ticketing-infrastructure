output "public_subnet_ids" {
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}

output "vpc_id" {
  value = aws_vpc.hub.id
}