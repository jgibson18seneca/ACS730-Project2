output "Public_VM_ids" {
    value = aws_instance.public_vw[*].id
}

output "private_VM_ids" {
    value = aws_instance.private_VM[*].id
}

output "ami_ids" {
    value = aws_instance.public_vw[*].ami
}
