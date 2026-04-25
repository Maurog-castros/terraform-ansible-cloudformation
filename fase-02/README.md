# Fase 02 - Primer Recurso Simple

## Lo que se espera

Crear un recurso minimo equivalente con cada herramienta:

- Terraform: archivo local o bucket S3 de prueba.
- Ansible: archivo de configuracion local usando playbook.
- CloudFormation: stack simple con un bucket S3 versionado.

## Lo que se practica

- `terraform init`, `terraform plan`, `terraform apply`, `terraform destroy`.
- `ansible-playbook --check` y ejecucion real.
- `aws cloudformation validate-template`, `deploy` y `delete-stack`.
- Diferencia entre declarar infraestructura y configurar estado.

## Resultado esperado

Al terminar, debe existir un artefacto verificable por cada enfoque:

- Terraform crea un output o recurso identificable.
- Ansible crea o modifica un archivo controlado.
- CloudFormation crea un stack con estado `CREATE_COMPLETE`.

## Validacion

Terraform:

```powershell
terraform -chdir=.\fase-02\terraform init
terraform -chdir=.\fase-02\terraform plan
terraform -chdir=.\fase-02\terraform apply
terraform -chdir=.\fase-02\terraform output
```

Ansible:

```powershell
ansible-playbook .\fase-02\ansible\playbook.yml --check
ansible-playbook .\fase-02\ansible\playbook.yml
```

CloudFormation:

```powershell
aws cloudformation validate-template --template-body file://fase-02/cloudformation/template.yml
aws cloudformation deploy --stack-name tac-lab-fase-02 --template-file fase-02/cloudformation/template.yml
aws cloudformation describe-stacks --stack-name tac-lab-fase-02
```

## Rollback

Terraform:

```powershell
terraform -chdir=.\fase-02\terraform destroy
```

Ansible:

```powershell
Remove-Item -Force .\fase-02\ansible\generated\* -ErrorAction SilentlyContinue
```

CloudFormation:

```powershell
aws cloudformation delete-stack --stack-name tac-lab-fase-02
aws cloudformation wait stack-delete-complete --stack-name tac-lab-fase-02
```

## Criterio de cierre

La fase queda completa cuando puedes crear, verificar y borrar los artefactos de las tres herramientas.

