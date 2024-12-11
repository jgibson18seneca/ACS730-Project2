output "Public_VM_ids" {
    value = aws_instance.public_vw[*].id
}

output "private_VM_ids" {
    value = aws_instance.private_VM[*].id
}

output "public_sg" {
    value = aws_security_group.public_sg.id
}

output "key_name" {
    value = aws_key_pair.project.id
}
