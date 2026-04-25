# Fase 05 - Observabilidad, Drift y Operaciones Day 2

## Lo que se espera

Extender la infraestructura con validaciones operativas: logs, health checks, deteccion de drift y recuperacion controlada.

## Lo que se practica

- Terraform plan como detector de drift.
- CloudFormation drift detection.
- Ansible facts y checks de estado.
- Logs y metricas basicas en CloudWatch.
- Runbooks de incidente y rollback parcial.

## Resultado esperado

El laboratorio debe poder responder estas preguntas:

- Que cambio respecto al estado declarado?
- El servicio esta vivo?
- Donde veo logs?
- Como vuelvo a un estado conocido?

## Validacion

Terraform drift:

```powershell
terraform -chdir=.\fase-05\terraform plan -detailed-exitcode
```

CloudFormation drift:

```powershell
$drift = aws cloudformation detect-stack-drift --stack-name tac-lab-fase-05 | ConvertFrom-Json
aws cloudformation describe-stack-drift-detection-status --stack-drift-detection-id $drift.StackDriftDetectionId
aws cloudformation describe-stack-resource-drifts --stack-name tac-lab-fase-05
```

Ansible health:

```powershell
ansible-playbook -i .\fase-05\ansible\inventory.yml .\fase-05\ansible\healthcheck.yml
```

CloudWatch logs:

```powershell
aws logs describe-log-groups --log-group-name-prefix /tac-lab/fase-05
aws logs tail /tac-lab/fase-05/app --since 10m
```

## Rollback

Rollback parcial:

```powershell
ansible-playbook -i .\fase-05\ansible\inventory.yml .\fase-05\ansible\rollback-config.yml
terraform -chdir=.\fase-05\terraform apply
```

Rollback total:

```powershell
terraform -chdir=.\fase-05\terraform destroy
aws cloudformation delete-stack --stack-name tac-lab-fase-05
aws cloudformation wait stack-delete-complete --stack-name tac-lab-fase-05
```

## Criterio de cierre

La fase queda completa cuando puedes detectar drift, ver logs, ejecutar health checks y recuperar el estado esperado.

