# Estándares de eventos

## 1. Propósito

Este documento define las reglas que deberán cumplir los eventos publicados por los microservicios de OVSA Enterprise Operations.

Los objetivos son:

* Mantener eventos consistentes.
* Facilitar el consumo por distintos servicios.
* Permitir trazabilidad distribuida.
* Evitar cambios incompatibles accidentales.
* Reducir la pérdida y duplicación de mensajes.
* Mantener contratos comprensibles y versionados.

---

# 2. Cuándo utilizar un evento

Se utilizará un evento cuando un servicio necesite informar que ocurrió un hecho empresarial relevante.

Ejemplos:

* Se creó un trabajador.
* Se confirmó una entrada.
* Cambió el stock.
* Se completó una orden.
* Se generó un reporte.

No se utilizará un evento simplemente porque dos clases estén en microservicios diferentes.

---

# 3. Cuándo utilizar REST

Se utilizará REST cuando el solicitante necesite una respuesta inmediata para continuar.

Ejemplos:

* Verificar si un producto existe.
* Consultar una orden.
* Solicitar una reserva de stock.
* Consultar el estado de un reporte.
* Validar un trabajador.

La decisión se resumirá con esta pregunta:

```text
¿El proceso necesita la respuesta ahora para poder continuar?
```

Cuando la respuesta sea sí, se evaluará REST.

Cuando solamente sea necesario informar un hecho ocurrido, se evaluará un evento.

---

# 4. Convención de nombres

Los eventos utilizarán:

```text
dominio.recurso.accion-pasada.vN
```

Ejemplos:

```text
identity.employee.created.v1
inventory.receipt.confirmed.v1
inventory.stock.changed.v1
operations.work-order.completed.v1
reporting.report.completed.v1
```

## Reglas

* Todo estará escrito en inglés.
* Todo estará en minúsculas.
* Las partes se separarán mediante puntos.
* Los recursos compuestos utilizarán guiones.
* La acción deberá representar algo ocurrido.
* La versión se incluirá al final.
* El nombre no incluirá nombres de clases técnicas.

Correcto:

```text
operations.work-order.started.v1
```

Incorrecto:

```text
WorkOrderEvent
operations.start-work-order
rabbitmq.work-order-message
operations.workOrder.started
```

---

# 5. Sobre estándar

Todos los eventos utilizarán un sobre común.

Ejemplo:

```json
{
  "eventId": "c792a804-4c62-4450-9456-aaec8fb01d42",
  "eventType": "inventory.receipt.confirmed.v1",
  "eventVersion": 1,
  "occurredAt": "2026-08-06T05:00:00Z",
  "organizationId": "270f0a16-c71d-4097-9b75-eb136e4291fa",
  "aggregateType": "Receipt",
  "aggregateId": "7e0d0e85-9145-4c38-a8f2-227f879317c9",
  "correlationId": "85318879-2c78-429d-aa3d-e1e1c68b16d0",
  "causationId": "5bc60042-762e-4987-bd44-fdc1500d4b29",
  "source": "inventory-service",
  "payload": {
    "receiptId": "7e0d0e85-9145-4c38-a8f2-227f879317c9",
    "warehouseId": "a8803009-6937-46f4-be7b-5ed69aa3cba2",
    "itemCount": 3
  },
  "metadata": {
    "contentType": "application/json"
  }
}
```

---

# 6. Campos del sobre

## eventId

Identificador único del evento.

Reglas:

* Será un UUID.
* No se reutilizará.
* Permitirá detectar eventos duplicados.

## eventType

Nombre completo y versionado del evento.

Ejemplo:

```text
inventory.receipt.confirmed.v1
```

## eventVersion

Versión numérica del contrato.

Debe coincidir con el sufijo del tipo:

```text
eventType: inventory.receipt.confirmed.v1
eventVersion: 1
```

## occurredAt

Fecha y hora UTC en que ocurrió el hecho empresarial.

No representa necesariamente el momento exacto en que RabbitMQ recibió el mensaje.

## organizationId

Organización propietaria del hecho empresarial.

Este campo será obligatorio en los eventos empresariales iniciales.

## aggregateType

Tipo de agregado que originó el evento.

Ejemplos:

```text
Employee
Receipt
StockReservation
WorkOrder
ReportJob
```

## aggregateId

Identificador de la raíz del agregado.

## correlationId

Identificador utilizado para seguir el flujo completo entre HTTP, servicios, base de datos y eventos.

## causationId

Identificador de la solicitud, comando o evento que provocó este evento.

Puede utilizarse para reconstruir una cadena causal.

## source

Nombre del servicio productor.

Valores iniciales:

```text
identity-service
inventory-service
operations-service
reporting-service
```

## payload

Información específica del evento.

El payload deberá contener solamente la información necesaria para que los consumidores reaccionen.

## metadata

Datos técnicos opcionales que no forman parte del hecho empresarial.

---

# 7. Diseño del payload

El payload debe ser:

* Pequeño.
* Claro.
* Autocontenido para la reacción esperada.
* Estable.
* Independiente de las entidades JPA.
* Libre de secretos.

No se publicará automáticamente una entidad completa.

Ejemplo incorrecto:

```json
{
  "employee": {
    "id": "uuid",
    "firstName": "Juan",
    "lastName": "Pérez",
    "email": "juan@example.com",
    "phone": "+56...",
    "address": "...",
    "documentNumber": "...",
    "password": "...",
    "roles": [],
    "internalNotes": "..."
  }
}
```

Ejemplo correcto:

```json
{
  "employeeId": "uuid",
  "employeeCode": "EMP-0001",
  "status": "ACTIVE"
}
```

La información personal solo se incluirá cuando exista una necesidad empresarial y de seguridad claramente justificada.

---

# 8. Eventos de dominio e integración

## Evento de dominio

Representa algo ocurrido dentro del modelo del servicio.

Ejemplo conceptual:

```text
ReceiptConfirmed
```

## Evento de integración

Representa el contrato publicado hacia otros servicios.

Ejemplo:

```text
inventory.receipt.confirmed.v1
```

No todos los eventos internos del dominio tienen que publicarse externamente.

El servicio podrá transformar un evento interno en un evento de integración estable.

---

# 9. Inmutabilidad

Un evento publicado representa historia empresarial.

No deberá modificarse después de publicarse.

Si el dato anterior era incorrecto, deberá publicarse un nuevo evento que represente la corrección o compensación.

---

# 10. Versionado

## Cambio compatible

Generalmente se considerarán compatibles:

* Agregar un campo opcional.
* Agregar metadatos opcionales.
* Agregar un nuevo tipo de evento.
* Ampliar documentación sin cambiar significado.

## Cambio incompatible

Se considerarán incompatibles:

* Eliminar un campo obligatorio.
* Renombrar un campo.
* Cambiar el tipo de un campo.
* Cambiar el significado empresarial.
* Convertir un campo opcional en obligatorio.
* Cambiar la estructura principal del payload.

Un cambio incompatible requiere una nueva versión:

```text
inventory.receipt.confirmed.v2
```

Durante una migración podrán publicarse temporalmente las versiones 1 y 2.

---

# 11. Orden de eventos

No se asumirá un orden global entre todos los mensajes.

Cuando el orden sea importante se considerará:

* El mismo agregado.
* El número de versión del agregado.
* La fecha del evento.
* La secuencia empresarial.
* La clave de enrutamiento.

Los consumidores deberán manejar eventos retrasados cuando sea razonablemente posible.

---

# 12. Duplicados

Los consumidores deberán asumir que un mismo `eventId` puede recibirse más de una vez.

El procesamiento deberá ser idempotente.

La recepción duplicada no debe:

* Crear dos auditorías equivalentes.
* Descontar dos veces el stock.
* Generar dos archivos.
* Enviar dos notificaciones irreversibles.
* Duplicar modelos de lectura.

---

# 13. Errores

Un consumidor deberá distinguir entre:

## Error temporal

Ejemplos:

* Base de datos momentáneamente no disponible.
* Timeout.
* Problema transitorio de red.

Podrá reintentarse.

## Error permanente

Ejemplos:

* Payload inválido.
* Versión no soportada.
* Campo obligatorio ausente.
* Regla imposible de satisfacer.

No deberá reintentarse indefinidamente.

El mensaje deberá terminar en una dead-letter queue.

---

# 14. Seguridad

Los eventos no deberán contener:

* Contraseñas.
* Tokens.
* Secretos.
* Claves privadas.
* Cookies.
* Datos financieros innecesarios.
* Información personal sin justificación.
* Stack traces completos.

Las colas y exchanges deberán requerir autenticación y permisos.

Cada servicio tendrá credenciales propias.

---

# 15. Trazabilidad

Los siguientes valores deberán propagarse:

```text
eventId
correlationId
causationId
organizationId
aggregateId
```

Los logs del productor y consumidor deberán incluir como mínimo:

```text
eventId
eventType
correlationId
consumer
result
```

---

# 16. Regla principal

Un evento publicado es un contrato histórico, no una copia accidental del estado interno del productor.
