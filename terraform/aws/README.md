# Terraform - AWS


**Atenção:** rodar esses recursos na AWS gera custos. Use com cuidado e lembre-se de `terraform destroy`.


Como usar:


1. Configure suas credenciais AWS (AWS CLI config ou variáveis de ambiente).
2. Preencha `terraform.tfvars` com `key_name` e `db_password`.
3. Rode:


```bash
terraform init
terraform apply -auto-approve

4. A saída fornecerá o IP público da EC2 e o endpoint do RDS.

Para destruir: 

terraform destroy -auto-approve