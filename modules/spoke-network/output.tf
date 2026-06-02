output "private_subnet_ids" {
  value = [aws_subnet.private_a.id, aws_subnet.private_b.id]
}

output "vpc_id" {
  value = aws_vpc.spoke.id
}