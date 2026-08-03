# Lenguaje ubicuo

## 1. Propósito

Este documento define el vocabulario oficial de OVSA Enterprise Operations.

Los mismos términos deberán utilizarse en:

* Conversaciones del equipo.
* Documentación.
* Historias de usuario.
* Clases Java.
* Interfaces TypeScript.
* Endpoints REST.
* Tablas de base de datos.
* Eventos.
* Pruebas.
* Mensajes de error.

No se deberán utilizar diferentes palabras para representar el mismo concepto sin una razón documentada.

---

# 2. Convención de idiomas

La documentación funcional y la interfaz de usuario estarán en español.

El código fuente utilizará nombres en inglés.

Ejemplos:

| Interfaz en español      | Código en inglés  |
| ------------------------ | ----------------- |
| Organización             | `Organization`    |
| Trabajador               | `Employee`        |
| Producto                 | `Product`         |
| Bodega                   | `Warehouse`       |
| Orden de trabajo         | `WorkOrder`       |
| Merma                    | `Waste`           |
| Solicitud de materiales  | `MaterialRequest` |
| Movimiento de inventario | `StockMovement`   |

No se mezclarán idiomas dentro de un mismo identificador.

Incorrecto:

```text
crearProduct
bodegaService
trabajadorRepository
```

Correcto:

```text
createProduct
warehouseService
employeeRepository
```

---

# 3. Términos generales

## Organization

Empresa o institución que utiliza OVSA.

Una organización es el límite principal de separación de datos.

## Branch

Sucursal perteneciente a una organización.

## Department

Área organizacional a la que puede pertenecer un trabajador.

## User

Cuenta autorizada para acceder a la plataforma.

Un usuario representa acceso al sistema.

## Employee

Persona registrada como trabajador de una organización.

Un trabajador puede existir sin tener una cuenta de usuario.

## Role

Agrupación de permisos asignable a un usuario.

## Permission

Autorización para ejecutar una acción específica.

## Status

Estado actual de una entidad o proceso.

Los estados deberán definirse explícitamente y no utilizar textos libres.

## Organization ID

Identificador de la organización propietaria de un registro.

---

# 4. Términos de inventario

## Product

Artículo administrado por el sistema de inventario.

## SKU

Código interno único de un producto dentro de una organización.

## Barcode

Código de barras opcional asociado a un producto.

## Category

Clasificación empresarial de productos.

## Unit of Measure

Unidad utilizada para expresar una cantidad.

Ejemplos:

* Unidad.
* Kilogramo.
* Litro.
* Metro.
* Caja.

## Supplier

Empresa o persona jurídica que suministra productos.

## Warehouse

Instalación física o lógica donde se almacenan productos.

## Warehouse Zone

Área interna de una bodega.

## Storage Location

Posición específica dentro de una bodega.

## Lot

Grupo de unidades de un mismo producto que comparte propiedades de fabricación o vencimiento.

## Serial Number

Identificador único asignado a una unidad específica.

## Stock

Cantidad registrada de un producto.

## Available Stock

Cantidad que puede utilizarse o reservarse.

## Reserved Stock

Cantidad comprometida temporalmente para una operación.

## Damaged Stock

Cantidad identificada como dañada o no utilizable.

## Stock Balance

Saldo actual de un producto en una ubicación.

## Stock Movement

Registro inmutable de un cambio confirmado en el stock.

## Receipt

Documento de entrada de productos al inventario.

No debe utilizarse `Entry` para este concepto en el código.

## Issue

Documento de salida de productos desde el inventario.

No debe utilizarse `Exit` para este concepto en el código.

## Transfer

Movimiento de productos entre bodegas o ubicaciones.

## Return

Ingreso de productos previamente entregados o retirados.

## Waste

Pérdida, daño, vencimiento o inutilización de productos.

## Adjustment

Corrección autorizada de un saldo de inventario.

## Reservation

Separación temporal de stock para una operación futura.

## Traceability

Capacidad de reconstruir el historial de un producto o movimiento.

---

# 5. Términos de operaciones

## Operational Site

Lugar donde se realiza una actividad empresarial.

Puede representar una estación, instalación, planta, oficina o centro operativo.

## Work Order

Unidad principal de planificación y ejecución de un trabajo.

## Work Order Type

Clasificación de una orden de trabajo.

## Work Order Task

Actividad específica que forma parte de una orden.

## Assignment

Relación entre una orden de trabajo y los trabajadores responsables.

## Assignee

Trabajador asignado a una orden o tarea.

## Supervisor

Trabajador responsable de controlar una orden.

## Priority

Nivel de importancia o urgencia de una orden.

Valores iniciales:

* `LOW`
* `NORMAL`
* `HIGH`
* `CRITICAL`

## Material Request

Solicitud de productos necesarios para ejecutar una orden.

## Material Request Item

Producto y cantidad solicitada dentro de una solicitud.

## Material Delivery

Registro de productos entregados para una orden.

## Material Return

Registro de productos devueltos después de una entrega.

## Evidence

Archivo o dato utilizado para demostrar la ejecución de una tarea.

## Work Order Status

Estado de una orden de trabajo.

Estados iniciales:

* `DRAFT`
* `PLANNED`
* `ASSIGNED`
* `IN_PROGRESS`
* `PAUSED`
* `PENDING_REVIEW`
* `COMPLETED`
* `CANCELLED`

---

# 6. Términos de reporting

## Dashboard

Vista resumida de indicadores empresariales.

## Report

Representación estructurada de información empresarial.

## Report Job

Proceso de generación de un reporte.

## Report File

Archivo resultante de un reporte.

## Read Model

Estructura optimizada para realizar consultas.

## Audit Event

Registro de una acción relevante dentro del sistema.

## Alert

Situación detectada que requiere revisión o acción.

## Acknowledged Alert

Alerta que fue vista y reconocida por un usuario.

## Closed Alert

Alerta cuya situación fue resuelta o descartada.

---

# 7. Términos técnicos

## Command

Solicitud explícita para modificar el estado del sistema.

Los comandos se nombrarán usando verbo y sustantivo.

Ejemplos:

* `CreateProduct`
* `ConfirmReceipt`
* `ReserveStock`
* `StartWorkOrder`

## Domain Event

Hecho empresarial que ya ocurrió.

Los eventos se nombrarán en tiempo pasado.

Ejemplos:

* `ProductCreated`
* `ReceiptConfirmed`
* `StockReserved`
* `WorkOrderStarted`

## Aggregate

Grupo de objetos empresariales que se modifica de forma consistente como una unidad.

## Aggregate Root

Entidad principal mediante la que se accede a un agregado.

## Value Object

Objeto definido por sus valores y sin identidad independiente.

## Repository

Abstracción utilizada para guardar y recuperar agregados.

## Application Service

Componente que coordina un caso de uso.

## Domain Service

Componente que contiene una regla empresarial que no pertenece naturalmente a una sola entidad.

## API Gateway

Punto de entrada para las solicitudes realizadas desde la aplicación web.

## Correlation ID

Identificador utilizado para seguir una solicitud entre varios componentes.

## Idempotency Key

Identificador utilizado para evitar que una misma operación sea procesada más de una vez.

## Outbox Event

Evento almacenado junto con una transacción empresarial antes de ser publicado.

## Processed Event

Registro que permite saber si un consumidor ya procesó un evento.

---

# 8. Reglas de nomenclatura

## Clases

Usar PascalCase:

```text
Product
WorkOrder
StockReservation
```

## Métodos y variables

Usar camelCase:

```text
createProduct
availableQuantity
organizationId
```

## Tablas y columnas

Usar snake_case:

```text
work_order
stock_balance
organization_id
created_at
```

## Endpoints

Usar minúsculas, palabras en plural y guiones:

```text
/api/v1/products
/api/v1/work-orders
/api/v1/material-requests
```

## Eventos publicados

Usar dominio, concepto, acción pasada y versión:

```text
inventory.product.created.v1
inventory.receipt.confirmed.v1
operations.work-order.started.v1
identity.employee.created.v1
```

## Permisos

Usar recurso y acción:

```text
product:create
stock:view
receipt:confirm
work-order:assign
report:generate
```

---

# 9. Términos que no deben utilizarse de forma ambigua

## Persona

No deberá utilizarse como reemplazo genérico de `User` o `Employee`.

Se deberá indicar si se habla de una cuenta de acceso o de un trabajador.

## Entrada

En código deberá utilizarse `Receipt`.

## Salida

En código deberá utilizarse `Issue`.

## Trabajo

Se deberá especificar:

* `WorkOrder`
* `WorkOrderTask`
* `WorkOrderType`

## Cantidad

Se deberá especificar cuando corresponda:

* `availableQuantity`
* `reservedQuantity`
* `damagedQuantity`
* `requestedQuantity`
* `deliveredQuantity`
* `returnedQuantity`

## Estado

Se deberá indicar la entidad:

* `UserStatus`
* `ProductStatus`
* `ReceiptStatus`
* `WorkOrderStatus`
* `ReportJobStatus`

---

# 10. Regla principal

Cuando una palabra pueda tener más de un significado, deberá utilizarse el término más específico.

El lenguaje utilizado en el código debe representar el negocio y no solamente detalles técnicos.
