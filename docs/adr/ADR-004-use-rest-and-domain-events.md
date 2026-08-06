# Contenido de `docs/adr/ADR-004-use-rest-and-domain-events.md`

# ADR-004: utilizar REST y eventos de dominio

## Estado

Accepted.

## Fecha

2026-08-03.

## Contexto

Los microservicios de OVSA deberán colaborar.

Existen dos necesidades diferentes:

1. Solicitudes que requieren respuesta inmediata.
2. Notificaciones sobre hechos que ya ocurrieron.

Utilizar solamente comunicación síncrona produciría cadenas largas de llamadas y mayor acoplamiento.

Utilizar solamente eventos dificultaría operaciones que necesitan respuestas inmediatas para continuar.

## Decisión

OVSA utilizará dos mecanismos principales de comunicación.

### REST síncrono

Se utilizará cuando el solicitante necesite una respuesta inmediata.

Ejemplos:

* Consultar un trabajador.
* Verificar un producto.
* Crear una reserva de stock.
* Obtener el estado de una orden.
* Validar una organización.

### Eventos asíncronos

Se utilizarán para informar hechos empresariales ocurridos.

Ejemplos:

* `identity.employee.created.v1`
* `inventory.receipt.confirmed.v1`
* `inventory.stock.changed.v1`
* `operations.work-order.completed.v1`

Inicialmente se utilizará RabbitMQ como broker de mensajes.

## Principio de selección

La pregunta para elegir será:

```text
¿El proceso necesita la respuesta para continuar ahora?
```

Cuando la respuesta sea sí, se considerará REST.

Cuando el proceso solamente necesite informar un hecho ocurrido, se considerará un evento.

## Alternativas consideradas

### Solamente REST

Ventajas:

* Flujo fácil de seguir.
* Respuestas inmediatas.
* Depuración inicial sencilla.

Desventajas:

* Mayor acoplamiento temporal.
* Cadenas de llamadas.
* Menor tolerancia a servicios temporalmente no disponibles.
* Reporting dependería de muchos servicios.

### Solamente eventos

Ventajas:

* Mayor desacoplamiento.
* Mejor tolerancia temporal.
* Escalamiento independiente de consumidores.

Desventajas:

* Mayor complejidad.
* Consistencia eventual.
* Difícil para validaciones inmediatas.
* Requiere correlación y seguimiento.

### REST y eventos

Permite seleccionar el mecanismo según la necesidad empresarial.

Esta es la alternativa seleccionada.

## Estándares REST

Las API deberán:

* Utilizar `/api/v1`.
* Recibir y responder JSON.
* Aplicar paginación.
* Utilizar códigos HTTP apropiados.
* Publicar contratos OpenAPI.
* Propagar `X-Correlation-ID`.
* Soportar `Idempotency-Key` en operaciones críticas.
* No exponer entidades JPA directamente.

## Estándares de eventos

Los eventos deberán incluir como mínimo:

```json
{
  "eventId": "uuid",
  "eventType": "inventory.stock.changed.v1",
  "eventVersion": 1,
  "occurredAt": "2026-08-03T18:00:00Z",
  "organizationId": "uuid",
  "aggregateId": "uuid",
  "correlationId": "uuid",
  "source": "inventory-service",
  "payload": {}
}
```

## Versionado

Los nombres seguirán esta estructura:

```text
dominio.recurso.accion-pasada.vN
```

Ejemplos:

```text
identity.employee.created.v1
inventory.receipt.confirmed.v1
operations.work-order.started.v1
reporting.report.completed.v1
```

Un cambio incompatible requerirá una nueva versión.

## Confiabilidad

Para evitar perder eventos se utilizará Outbox Pattern.

Dentro de la misma transacción local:

1. Se actualiza el dominio.
2. Se guarda el evento en la tabla outbox.
3. Un publicador envía el evento al broker.
4. El evento se marca como publicado.

Los consumidores deberán ser idempotentes.

## Consecuencias positivas

* Los flujos inmediatos tendrán respuestas claras.
* Reporting podrá desacoplarse mediante eventos.
* Los servicios podrán reaccionar a hechos empresariales.
* Se reducirá el acoplamiento temporal en procesos asíncronos.
* Los contratos quedarán explícitos y versionados.

## Consecuencias negativas

* Existirán dos modelos de integración.
* Será necesario supervisar colas.
* Los consumidores deberán manejar duplicados.
* Se deberá implementar dead-letter queue.
* La consistencia eventual deberá comunicarse al usuario.
* La depuración requerirá correlation IDs y trazas.

## Reglas derivadas

* No se publicarán eventos antes de confirmar la transacción.
* Un evento representará un hecho ocurrido.
* Los comandos no deberán publicarse como si fueran eventos.
* Los consumidores serán idempotentes.
* No existirán reintentos infinitos.
* Los mensajes fallidos terminarán en una DLQ.
* Los eventos no incluirán secretos ni datos sensibles innecesarios.
* Un evento publicado será tratado como un contrato.

## Criterio de revisión

La decisión deberá revisarse si:

* RabbitMQ deja de satisfacer las necesidades de volumen.
* Se requiere retención y reproducción extensa de eventos.
* Se adopta una plataforma de streaming.
* Las llamadas REST generan dependencias circulares.
* Un proceso distribuido necesita una saga formal.