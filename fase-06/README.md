# Fase 06 - Mini Plataforma Logistica Reproducible

## Lo que se espera

Construir una mini plataforma de laboratorio inspirada en operaciones logisticas China a Chile:

- API o servicio simple para tracking de BL.
- Storage para eventos de ETA/ETD.
- Configuracion automatizada del host.
- Logs operativos para auditoria.

## Lo que se practica

- Terraform para infraestructura principal.
- CloudFormation para un stack AWS especifico y comparable.
- Ansible para configurar runtime y desplegar servicio.
- Transacciones operativas: deploy, validate, rollback.
- Observabilidad orientada a negocio: eventos de BL, ETA, ETD y errores.

## Resultado esperado

Debe existir un flujo reproducible:

1. Provisionar infraestructura.
2. Configurar servidor.
3. Publicar servicio de tracking.
4. Enviar evento de prueba.
5. Verificar log o respuesta.
6. Ejecutar rollback.

Ejemplo de evento:

```json
{
  "bill_of_lading": "TACLAB123456",
  "origin_port": "CNSHA",
  "destination_port": "CLSAI",
  "eta": null,
  "etd": "2026-05-15T00:00:00Z",
  "status": "IN_TRANSIT"
}
```

## Validacion

Infraestructura:

```powershell
terraform -chdir=.\fase-06\terraform validate
terraform -chdir=.\fase-06\terraform plan
terraform -chdir=.\fase-06\terraform apply
```

Stack AWS:

```powershell
aws cloudformation validate-template --template-body file://fase-06/cloudformation/observability.yml
aws cloudformation deploy --stack-name tac-lab-fase-06-observability --template-file fase-06/cloudformation/observability.yml
```

Configuracion:

```powershell
ansible-playbook -i .\fase-06\ansible\inventory.yml .\fase-06\ansible\site.yml
ansible-playbook -i .\fase-06\ansible\inventory.yml .\fase-06\ansible\healthcheck.yml
```

Prueba funcional:

```powershell
Invoke-RestMethod -Method Post -Uri http://localhost:8080/events -ContentType "application/json" -Body '{"bill_of_lading":"TACLAB123456","origin_port":"CNSHA","destination_port":"CLSAI","eta":null,"etd":"2026-05-15T00:00:00Z","status":"IN_TRANSIT"}'
```

## Rollback

Orden recomendado:

1. Pausar o remover servicio con Ansible.
2. Exportar logs si se necesitan para auditoria.
3. Destruir infraestructura Terraform.
4. Eliminar stack CloudFormation.

Comandos:

```powershell
ansible-playbook -i .\fase-06\ansible\inventory.yml .\fase-06\ansible\rollback.yml
terraform -chdir=.\fase-06\terraform destroy
aws cloudformation delete-stack --stack-name tac-lab-fase-06-observability
aws cloudformation wait stack-delete-complete --stack-name tac-lab-fase-06-observability
```

## Criterio de cierre

La fase queda completa cuando el flujo completo se puede crear, probar, observar y destruir sin dejar recursos vivos.

