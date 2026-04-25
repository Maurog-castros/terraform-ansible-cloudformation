# Terraform + Ansible + CloudFormation Lab

Laboratorio incremental para practicar Terraform, Ansible y CloudFormation en paralelo, con foco en infraestructura verificable, rollback claro y mentalidad Day 2 Operations.

## Objetivo

Construir el mismo caso de aprendizaje desde tres enfoques:

- Terraform: provisionar y mantener infraestructura declarativa multi-recurso.
- Ansible: configurar, validar y operar servidores o recursos existentes.
- CloudFormation: entender el modelo nativo de AWS para stacks versionados.

Cada fase vive en su propia carpeta y contiene un `README.md` con:

- Lo que se espera construir.
- Lo que se practica.
- Resultado esperado.
- Validacion.
- Rollback.

## Reglas del laboratorio

- No subir secretos reales al repo.
- Usar `.env` solo como referencia local.
- Validar antes de aplicar cambios destructivos.
- Todo recurso creado debe tener rollback documentado.
- Preferir recursos de bajo costo o sin costo en las primeras fases.
- Nombrar recursos con prefijo claro, por ejemplo `tac-lab-fase-01`.

## Fases

| Fase | Tema | Dificultad |
| --- | --- | --- |
| [Fase 01](fase-01/README.md) | Setup local, CLI, estructura y validacion sin nube | Basica |
| [Fase 02](fase-02/README.md) | Primer recurso simple por herramienta | Basica |
| [Fase 03](fase-03/README.md) | Variables, parametros, outputs e inventario | Intermedia |
| [Fase 04](fase-04/README.md) | Red, seguridad y configuracion de servidor | Intermedia |
| [Fase 05](fase-05/README.md) | Observabilidad, drift y operaciones Day 2 | Avanzada |
| [Fase 06](fase-06/README.md) | Mini plataforma logistica reproducible | Avanzada |

## Flujo recomendado por fase

1. Leer el `README.md` de la fase.
2. Ejecutar validaciones locales.
3. Aplicar solo si el plan es entendible.
4. Verificar outputs o estado final.
5. Ejecutar rollback.
6. Confirmar que no quedan recursos vivos.

