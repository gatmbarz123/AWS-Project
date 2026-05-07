output "source_backup_vault_arn" {
  value = aws_backup_vault.source.arn
}

output "destination_backup_vault_arn" {
  value = aws_backup_vault.destination.arn
}

output "backup_plan_id" {
  value = aws_backup_plan.plan.id
}

output "backup_selection_id" {
  value = aws_backup_selection.tagged.id
}