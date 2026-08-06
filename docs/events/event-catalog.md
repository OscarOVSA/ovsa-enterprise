# Catálogo de eventos

## 1. Propósito

Este documento contiene los eventos de integración iniciales de OVSA Enterprise Operations.

El catálogo define:

* Productor.
* Tipo del evento.
* Agregado.
* Consumidores previstos.
* Propósito.
* Campos principales del payload.

El hecho de que un consumidor aparezca aquí no significa que el productor dependa de él.

---

# 2. Eventos de Identity

## identity.organization.created.v1

**Productor:** Identity Service
**Agregado:** Organization
**Consumidores previstos:** Reporting Service

Se publica cuando una organización fue creada correctamente.

Payload inicial:

```json
{
  "organizationId": "uuid",
  "businessName": "OVSA Servicios SpA",
  "status": "ACTIVE"
}
```

## identity.organization.activated.v1

**Productor:** Identity Service
**Agregado:** Organization
**Consumidores previstos:** Reporting Service

Se publica cuando una organización queda activa.

## identity.organization.deactivated.v1

**Productor:** Identity Service
**Agregado:** Organization
**Consumidores previstos:** Reporting Service

Se publica cuando una organización queda inactiva.

## identity.employee.created.v1

**Productor:** Identity Service
**Agregado:** Employee
**Consumidores previstos:** Operations Service y Reporting Service

Payload inicial:

```json
{
  "employeeId": "uuid",
  "employeeCode": "EMP-0001",
  "status": "ACTIVE"
}
```

## identity.employee.updated.v1

Se publica cuando cambian datos empresariales relevantes de un trabajador.

No debe utilizarse para publicar indiscriminadamente toda su información personal.

## identity.employee.deactivated.v1

Se publica cuando un trabajador deja de estar disponible para nuevas asignaciones.

## identity.user.created.v1

Se publica cuando se crea un usuario empresarial.

## identity.user.activated.v1

Se publica cuando el usuario queda habilitado.

## identity.user.deactivated.v1

Se publica cuando el usuario pierde acceso empresarial.

## identity.role.assigned.v1

Se publica cuando un rol se asigna correctamente a un usuario.

---

# 3. Eventos de Inventory

## inventory.product.created.v1

**Productor:** Inventory Service
**Agregado:** Product
**Consumidores previstos:** Reporting Service

Payload inicial:

```json
{
  "productId": "uuid",
  "sku": "PRD-0001",
  "name": "Cable de fibra óptica",
  "unitOfMeasure": "METER",
  "status": "ACTIVE"
}
```

## inventory.product.updated.v1

Se publica cuando cambian datos relevantes del producto.

## inventory.warehouse.created.v1

Se publica cuando una bodega queda disponible.

## inventory.receipt.confirmed.v1

**Productor:** Inventory Service
**Agregado:** Receipt
**Consumidores previstos:** Reporting Service

Se publica después de confirmar la entrada y actualizar correctamente el stock.

Payload inicial:

```json
{
  "receiptId": "uuid",
  "receiptNumber": "REC-2026-000001",
  "warehouseId": "uuid",
  "supplierId": "uuid",
  "itemCount": 3,
  "confirmedBy": "uuid",
  "confirmedAt": "2026-08-06T05:00:00Z"
}
```

## inventory.issue.confirmed.v1

Se publica después de confirmar una salida y descontar correctamente el stock.

## inventory.transfer.dispatched.v1

Se publica cuando los productos salen de la ubicación de origen.

## inventory.transfer.completed.v1

Se publica cuando los productos son recibidos en el destino.

## inventory.waste.confirmed.v1

Se publica cuando una merma queda confirmada y afecta al stock.

## inventory.stock.adjusted.v1

Se publica después de aplicar un ajuste autorizado.

## inventory.stock.reserved.v1

**Productor:** Inventory Service
**Agregado:** StockReservation
**Consumidores previstos:** Operations Service y Reporting Service

Payload inicial:

```json
{
  "reservationId": "uuid",
  "referenceType": "MATERIAL_REQUEST",
  "referenceId": "uuid",
  "warehouseId": "uuid",
  "expiresAt": "2026-08-06T06:00:00Z",
  "items": [
    {
      "productId": "uuid",
      "quantity": 10
    }
  ]
}
```

## inventory.stock.reservation-released.v1

Se publica cuando una reserva expira, se cancela o se libera.

## inventory.stock.changed.v1

Se publica cuando cambia un saldo confirmado.

Payload inicial:

```json
{
  "productId": "uuid",
  "warehouseId": "uuid",
  "locationId": "uuid",
  "previousAvailableQuantity": 100,
  "availableQuantity": 90,
  "reservedQuantity": 10,
  "damagedQuantity": 0,
  "reason": "STOCK_RESERVED"
}
```

## inventory.stock.low-detected.v1

Se publica cuando el saldo alcanza o cruza el mínimo configurado.

---

# 4. Eventos de Operations

## operations.work-order.created.v1

**Productor:** Operations Service
**Agregado:** WorkOrder
**Consumidores previstos:** Reporting Service

Payload inicial:

```json
{
  "workOrderId": "uuid",
  "code": "WO-2026-000001",
  "siteId": "uuid",
  "priority": "HIGH",
  "status": "DRAFT"
}
```

## operations.work-order.planned.v1

Se publica cuando la orden queda planificada.

## operations.work-order.assigned.v1

Se publica cuando uno o más trabajadores quedan asignados.

Payload inicial:

```json
{
  "workOrderId": "uuid",
  "employeeIds": [
    "uuid"
  ],
  "assignedBy": "uuid"
}
```

## operations.work-order.started.v1

Se publica cuando comienza la ejecución de la orden.

## operations.work-order.paused.v1

Se publica cuando la orden se pausa.

## operations.work-order.resumed.v1

Se publica cuando una orden pausada vuelve a ejecución.

## operations.work-order.submitted-for-review.v1

Se publica cuando el trabajo queda pendiente de revisión.

## operations.work-order.completed.v1

Se publica cuando la orden cumple las condiciones necesarias y queda completada.

## operations.work-order.cancelled.v1

Se publica cuando una orden es cancelada.

## operations.material-request.created.v1

**Productor:** Operations Service
**Agregado:** MaterialRequest
**Consumidores previstos:** Inventory Service y Reporting Service

Payload inicial:

```json
{
  "materialRequestId": "uuid",
  "workOrderId": "uuid",
  "warehouseId": "uuid",
  "items": [
    {
      "productId": "uuid",
      "requestedQuantity": 10
    }
  ]
}
```

## operations.material-request.approved.v1

Se publica cuando una solicitud queda aprobada.

## operations.material-request.rejected.v1

Se publica cuando una solicitud no puede aprobarse.

## operations.material.delivered.v1

Se publica cuando los materiales fueron entregados a la operación.

## operations.material.returned.v1

Se publica cuando los materiales no utilizados fueron devueltos.

---

# 5. Eventos de Reporting

## reporting.report.requested.v1

**Productor:** Reporting Service
**Agregado:** ReportJob

Se publica cuando se registra un nuevo trabajo de generación.

## reporting.report.completed.v1

Se publica cuando el archivo fue generado correctamente.

Payload inicial:

```json
{
  "reportJobId": "uuid",
  "reportType": "INVENTORY",
  "format": "PDF",
  "fileId": "uuid",
  "completedAt": "2026-08-06T05:10:00Z",
  "expiresAt": "2026-08-13T05:10:00Z"
}
```

## reporting.report.failed.v1

Se publica cuando el reporte no pudo generarse.

El payload deberá incluir un código seguro y estable, no un stack trace.

## reporting.alert.created.v1

Se publica cuando se crea una alerta que requiere atención.

## reporting.alert.acknowledged.v1

Se publica cuando un usuario reconoce una alerta.

## reporting.alert.closed.v1

Se publica cuando una alerta se resuelve o descarta.

---

# 6. Tabla resumida

| Evento                                   | Productor  | Consumidor principal   |
| ---------------------------------------- | ---------- | ---------------------- |
| `identity.employee.created.v1`           | Identity   | Operations, Reporting  |
| `identity.employee.deactivated.v1`       | Identity   | Operations, Reporting  |
| `inventory.receipt.confirmed.v1`         | Inventory  | Reporting              |
| `inventory.issue.confirmed.v1`           | Inventory  | Reporting              |
| `inventory.stock.reserved.v1`            | Inventory  | Operations, Reporting  |
| `inventory.stock.changed.v1`             | Inventory  | Reporting              |
| `operations.work-order.created.v1`       | Operations | Reporting              |
| `operations.work-order.completed.v1`     | Operations | Reporting              |
| `operations.material-request.created.v1` | Operations | Inventory, Reporting   |
| `operations.material.delivered.v1`       | Operations | Reporting              |
| `reporting.report.completed.v1`          | Reporting  | Notificaciones futuras |
| `reporting.alert.created.v1`             | Reporting  | Notificaciones futuras |

---

# 7. Registro de cambios

Cada cambio del catálogo deberá indicar:

* Evento afectado.
* Motivo.
* Compatibilidad.
* Productores afectados.
* Consumidores afectados.
* Plan de migración.

No deberá cambiarse un payload publicado sin revisar previamente a sus consumidores.