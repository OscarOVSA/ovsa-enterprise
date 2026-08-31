# Backlog de OVSA Enterprise Operations

## Propósito

Esta carpeta contiene la planificación funcional y técnica de OVSA Enterprise Operations.

El backlog transforma los requisitos, dominios y decisiones arquitectónicas en trabajo implementable.

## Documentos

| Documento                | Propósito                              |
| ------------------------ | -------------------------------------- |
| `product-backlog.md`     | Backlog general priorizado             |
| `sprint-roadmap.md`      | Orden previsto de implementación       |
| `sprint-1-backlog.md`    | Trabajo detallado del siguiente sprint |
| `user-story-template.md` | Plantilla para nuevas historias        |

## Jerarquía

OVSA utilizará:

```text
Epic
  ↓
User Story
  ↓
Technical Tasks
  ↓
Tests and Evidence
```

## Identificadores

Las historias utilizarán identificadores estables.

Ejemplos:

```text
IAM-001
INV-001
OPS-001
REP-001
PLT-001
WEB-001
```

Prefijos:

| Prefijo | Área           |
| ------- | -------------- |
| `PLT`   | Plataforma     |
| `IAM`   | Identity       |
| `INV`   | Inventory      |
| `OPS`   | Operations     |
| `REP`   | Reporting      |
| `WEB`   | Frontend       |
| `SEC`   | Seguridad      |
| `OBS`   | Observabilidad |
| `DEV`   | DevOps         |

## Prioridades

Se utilizarán inicialmente:

* `P0`: imprescindible para continuar.
* `P1`: necesaria para la primera versión.
* `P2`: importante, pero puede esperar.
* `P3`: mejora futura.

## Estados

Estados iniciales:

```text
BACKLOG
READY
IN_PROGRESS
IN_REVIEW
DONE
BLOCKED
```

## Definition of Ready

Una historia estará preparada para comenzar cuando:

* El objetivo empresarial sea comprensible.
* Los criterios de aceptación estén definidos.
* Las dependencias principales sean conocidas.
* El dominio propietario esté identificado.
* Los contratos afectados estén identificados.
* No exista una decisión arquitectónica pendiente que impida comenzar.

## Definition of Done

La Definition of Done oficial se encuentra en:

```text
docs/testing/definition-of-done.md
```

Una historia no estará terminada solamente porque el código compile.

## Regla principal

El backlog podrá cambiar conforme aprendamos, pero toda modificación importante de alcance deberá mantenerse alineada con la visión, los bounded contexts y las decisiones arquitectónicas.