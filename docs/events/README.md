# Eventos de OVSA

## Propósito

Esta carpeta contiene los contratos y estándares de comunicación asíncrona de OVSA Enterprise Operations.

Los eventos permiten que los microservicios informen hechos empresariales sin depender de que todos los consumidores estén disponibles al mismo tiempo.

## Documentos

| Archivo                              | Contenido                                    |
| ------------------------------------ | -------------------------------------------- |
| `event-standards.md`                 | Convenciones de diseño, nombres y versionado |
| `event-catalog.md`                   | Catálogo oficial de eventos                  |
| `reliability-patterns.md`            | Outbox, idempotencia, reintentos y DLQ       |
| `rabbitmq-topology.md`               | Exchanges, colas y bindings iniciales        |
| `schemas/event-envelope.schema.json` | Contrato JSON del sobre estándar             |

## Principios

* Un evento representa algo que ya ocurrió.
* Los eventos utilizan nombres en pasado.
* Todo evento tiene una versión.
* Los eventos publicados son contratos.
* Los consumidores deben tolerar entregas duplicadas.
* Los productores no deben depender de consumidores específicos.
* Los eventos no deben contener secretos.
* Los cambios incompatibles requieren una nueva versión.
* Un evento no reemplaza automáticamente una consulta REST.
* El broker no será utilizado como base de datos.

## Tecnología inicial

OVSA utilizará RabbitMQ como broker de mensajería durante la primera versión.

La comunicación utilizará exchanges de tipo `topic` y colas durables.

## Regla principal

La publicación de un evento empresarial no debe depender de una operación posterior ejecutada fuera de la transacción principal.

Para evitar pérdidas se utilizará Outbox Pattern.
