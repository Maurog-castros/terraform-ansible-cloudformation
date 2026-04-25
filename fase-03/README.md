# Fase 03 - Variables, Parametros, Outputs e Inventario

## Lo que se espera

Tomar el recurso simple de la fase anterior y hacerlo configurable sin editar el codigo principal.

## Lo que se practica

- Terraform variables, `tfvars`, outputs y locals.
- Ansible variables, inventory y templates.
- CloudFormation parameters, outputs y mappings.
- Convenciones de ambiente: `dev`, `test`, `prod`.

## Resultado esperado

El mismo codigo debe poder crear recursos con nombres distintos por ambiente:

- `tac-lab-dev-*`
- `tac-lab-test-*`

Los outputs deben exponer valores utiles para la siguiente herramienta. Ejemplo: un bucket creado por Terraform puede quedar como variable de Ansible o output de CloudFormation.

## Validacion

Terraform:

```powershell
terraform -chdir=.\fase-03\terraform validate
terraform -chdir=.\fase-03\terraform plan -var-file=dev.tfvars
```

Ansible:

```powershell
ansible-inventory -i .\fase-03\ansible\inventory.yml --list
ansible-playbook -i .\fase-03\ansible\inventory.yml .\fase-03\ansible\playbook.yml --check
```

CloudFormation:

```powershell
aws cloudformation validate-template --template-body file://fase-03/cloudformation/template.yml
aws cloudformation deploy --stack-name tac-lab-fase-03-dev --template-file fase-03/cloudformation/template.yml --parameter-overrides EnvironmentName=dev
aws cloudformation describe-stacks --stack-name tac-lab-fase-03-dev --query "Stacks[0].Outputs"
```

## Rollback

Terraform:

```powershell
terraform -chdir=.\fase-03\terraform destroy -var-file=dev.tfvars
```

CloudFormation:

```powershell
aws cloudformation delete-stack --stack-name tac-lab-fase-03-dev
aws cloudformation wait stack-delete-complete --stack-name tac-lab-fase-03-dev
```

Ansible:

```powershell
ansible-playbook -i .\fase-03\ansible\inventory.yml .\fase-03\ansible\rollback.yml
```

## Criterio de cierre

La fase queda completa cuando puedes cambiar ambiente por parametro y verificar que outputs e inventario reflejan el cambio.

