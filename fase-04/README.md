# Fase 04 - Red, Seguridad y Configuracion de Servidor

## Lo que se espera

Crear una infraestructura pequena y segura para una aplicacion interna de laboratorio.

## Lo que se practica

- Terraform: VPC, subnets, security groups o EC2 simple.
- CloudFormation: stack equivalente o complementario para comparar el modelo AWS nativo.
- Ansible: configurar paquetes, usuarios, archivos y servicio de ejemplo.
- Principio de menor privilegio en reglas de red.
- Manejo cuidadoso de cambios que pueden cortar acceso remoto.

## Resultado esperado

Debe existir una instancia o recurso computacional accesible solo por reglas declaradas, con configuracion aplicada por Ansible.

Ejemplo verificable:

- Puerto SSH limitado.
- Servicio HTTP de prueba activo.
- Archivo `/etc/tac-lab-release` o equivalente generado por Ansible.

## Validacion

Terraform:

```powershell
terraform -chdir=.\fase-04\terraform validate
terraform -chdir=.\fase-04\terraform plan
terraform -chdir=.\fase-04\terraform apply
terraform -chdir=.\fase-04\terraform output
```

Ansible:

```powershell
ansible -i .\fase-04\ansible\inventory.yml all -m ping
ansible-playbook -i .\fase-04\ansible\inventory.yml .\fase-04\ansible\site.yml --check
ansible-playbook -i .\fase-04\ansible\inventory.yml .\fase-04\ansible\site.yml
```

CloudFormation:

```powershell
aws cloudformation validate-template --template-body file://fase-04/cloudformation/network.yml
aws cloudformation describe-stack-events --stack-name tac-lab-fase-04
```

## Rollback

Orden recomendado:

1. Revertir configuracion Ansible si creo archivos o servicios persistentes.
2. Destruir recursos Terraform.
3. Eliminar stacks CloudFormation.

Comandos:

```powershell
ansible-playbook -i .\fase-04\ansible\inventory.yml .\fase-04\ansible\rollback.yml
terraform -chdir=.\fase-04\terraform destroy
aws cloudformation delete-stack --stack-name tac-lab-fase-04
aws cloudformation wait stack-delete-complete --stack-name tac-lab-fase-04
```

## Criterio de cierre

La fase queda completa cuando el servidor responde, la configuracion es reproducible y el rollback elimina infraestructura y cambios operativos.

