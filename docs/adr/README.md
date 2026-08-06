# Contenido de `docs/adr/README.md`

# Architecture Decision Records

## Propósito

Esta carpeta contiene las decisiones arquitectónicas de OVSA Enterprise Operations.

Cada ADR explica:

* El contexto de una decisión.
* El problema que debía resolverse.
* Las alternativas consideradas.
* La decisión seleccionada.
* Sus consecuencias positivas y negativas.

Los ADR forman parte permanente de la documentación del proyecto.

## Convención de nombres

Los archivos deberán utilizar esta estructura:

```text
ADR-NNN-descripcion-corta.md
```

Ejemplo:

```text
ADR-001-use-microservices-architecture.md
```

## Estados permitidos

* `Proposed`
* `Accepted`
* `Deprecated`
* `Superseded`

## Reglas

* Un ADR aceptado no deberá eliminarse.
* Una decisión modificada deberá registrarse mediante un nuevo ADR.
* El nuevo ADR deberá indicar qué decisión reemplaza.
* Los ADR deberán enfocarse en decisiones importantes y difíciles de cambiar.
* No se crearán ADR para decisiones menores de estilo de código.
* Las consecuencias negativas deberán documentarse con honestidad.

## Índice

| ADR                                                  | Decisión                                | Estado   |
| ---------------------------------------------------- | --------------------------------------- | -------- |
| [ADR-001](ADR-001-use-microservices-architecture.md) | Utilizar arquitectura de microservicios | Accepted |
| [ADR-002](ADR-002-define-four-business-contexts.md)  | Definir cuatro contextos empresariales  | Accepted |
| [ADR-003](ADR-003-database-per-service.md)           | Utilizar una base de datos por servicio | Accepted |
| [ADR-004](ADR-004-use-rest-and-domain-events.md)     | Utilizar REST y eventos de dominio      | Accepted |
| [ADR-005](ADR-005-use-hexagonal-architecture.md)     | Utilizar arquitectura hexagonal         | Accepted |
| [ADR-006](ADR-006-use-monorepo.md)                   | Utilizar un monorepo inicialmente       | Accepted |