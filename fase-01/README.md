# Fase 01 - Setup Local y Validacion Base

## Lo que se espera

Preparar el entorno local para trabajar con Terraform, Ansible y CloudFormation sin crear recursos reales en AWS.

## Lo que se practica

- Validar instalacion de herramientas.
- Entender comandos base.
- Separar responsabilidades entre IaC declarativa, configuracion y stacks AWS.
- Definir una convencion de nombres para recursos futuros.

## Resultado esperado

El entorno debe poder ejecutar comandos de version y validacion sin errores:

- `terraform version`
- `ansible --version`
- `aws --version`
- `aws sts get-caller-identity`

## Estructura sugerida

```text
fase-01/
  README.md
  terraform/
  ansible/
  cloudformation/
```

## Validacion

Ejecutar desde PowerShell:

```powershell
terraform version
ansible --version
aws --version
aws sts get-caller-identity
```

Verificar:

- Terraform responde version.
- Ansible responde version.
- AWS CLI responde version.
- `sts get-caller-identity` muestra cuenta, usuario o rol activo.

## Rollback

No hay recursos externos que destruir en esta fase.

Rollback local:

```powershell
Remove-Item -Recurse -Force .\fase-01\terraform\.terraform -ErrorAction SilentlyContinue
Remove-Item -Force .\fase-01\terraform\.terraform.lock.hcl -ErrorAction SilentlyContinue
```

## Criterio de cierre

La fase queda completa cuando las tres herramientas responden y AWS CLI puede identificar la cuenta activa.

