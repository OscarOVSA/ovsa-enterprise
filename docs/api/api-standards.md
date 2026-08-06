# Estándares REST de OVSA

## 1. Propósito

Este documento define las convenciones HTTP y REST que deberán seguir el API Gateway y los cuatro microservicios de OVSA Enterprise Operations.

Los objetivos son:

* Mantener contratos consistentes.
* Reducir decisiones repetidas.
* Facilitar el uso de las API.
* Permitir documentación automática.
* Facilitar pruebas y generación de clientes.
* Evitar respuestas diferentes para problemas equivalentes.

---

# 2. Formato

Las API utilizarán JSON.

## Content-Type

Las solicitudes con cuerpo utilizarán:

```http
Content-Type: application/json
```

El cliente indicará:

```http
Accept: application/json
```

Los errores utilizarán:

```http
Content-Type: application/problem+json
```

---

# 3. Versionado

Las rutas empresariales utilizarán versión explícita:

```text
/api/v1/products
/api/v1/work-orders
/api/v1/employees
```

La versión cambiará cuando exista una modificación incompatible que no pueda introducirse de manera segura en la versión actual.

No se utilizarán versiones como:

```text
/api/v1.1/products
/api/v2026/products
```

---

# 4. Nombres de rutas

Las rutas utilizarán:

* Sustantivos.
* Plural.
* Minúsculas.
* Guiones para conceptos compuestos.
* Nombres empresariales en inglés.

Correcto:

```text
/api/v1/products
/api/v1/work-orders
/api/v1/material-requests
/api/v1/stock-reservations
```

Incorrecto:

```text
/api/v1/getProducts
/api/v1/create-product
/api/v1/ordenesTrabajo
/api/v1/Product
```

---

# 5. Operaciones CRUD

## Crear

```http
POST /api/v1/products
```

Respuesta:

```http
201 Created
Location: /api/v1/products/{productId}
```

## Consultar colección

```http
GET /api/v1/products
```

## Consultar recurso

```http
GET /api/v1/products/{productId}
```

## Actualizar parcialmente

```http
PATCH /api/v1/products/{productId}
```

## Reemplazar completamente

`PUT` se utilizará solamente cuando el cliente envíe una representación completa del recurso.

## Eliminar

`DELETE` se utilizará únicamente cuando la eliminación sea válida para el negocio.

Los movimientos confirmados, auditorías y documentos empresariales no se eliminarán físicamente.

---

# 6. Acciones empresariales

Algunas operaciones no representan un CRUD simple.

Ejemplos:

```http
POST /api/v1/receipts/{receiptId}/confirm
POST /api/v1/work-orders/{workOrderId}/start
POST /api/v1/work-orders/{workOrderId}/complete
POST /api/v1/alerts/{alertId}/acknowledge
```

Estas acciones se utilizarán cuando exista:

* Una transición de estado.
* Una regla empresarial específica.
* Una autorización especial.
* Un efecto distinto de una actualización genérica.

No se utilizará `PATCH` para ocultar acciones empresariales importantes.

---

# 7. Códigos HTTP

## 200 OK

Operación exitosa que devuelve información.

Ejemplos:

* Consulta de un recurso.
* Consulta paginada.
* Actualización completada.
* Acción empresarial completada con respuesta.

## 201 Created

Recurso creado correctamente.

Se deberá devolver la representación creada y el encabezado `Location` cuando sea posible.

## 202 Accepted

La solicitud fue aceptada, pero continuará procesándose de forma asíncrona.

Ejemplo:

```http
POST /api/v1/reports/inventory
```

## 204 No Content

Operación exitosa sin cuerpo de respuesta.

## 400 Bad Request

La solicitud no puede interpretarse correctamente.

Ejemplos:

* JSON inválido.
* Parámetro con formato incorrecto.
* UUID inválido.
* Campo requerido ausente.

## 401 Unauthorized

No existe una autenticación válida.

Ejemplos:

* Token ausente.
* Token vencido.
* Firma inválida.
* Emisor inválido.

## 403 Forbidden

El usuario está autenticado, pero no tiene autorización suficiente.

## 404 Not Found

El recurso no existe dentro del contexto accesible por el usuario.

## 409 Conflict

La solicitud entra en conflicto con el estado actual.

Ejemplos:

* SKU duplicado.
* Entrada ya confirmada.
* Stock insuficiente.
* Conflicto de concurrencia.
* Transición de estado inválida.

## 422 Unprocessable Content

La estructura es válida, pero contiene datos que no cumplen una validación empresarial de entrada.

Ejemplos:

* Fecha final anterior a fecha inicial.
* Cantidad menor o igual que cero.
* Combinación de campos incompatible.

Los conflictos con el estado actual del sistema utilizarán preferentemente `409`.

## 429 Too Many Requests

El cliente superó el límite de solicitudes permitido.

## 500 Internal Server Error

Ocurrió un error no controlado.

La respuesta no deberá exponer:

* Stack traces.
* Consultas SQL.
* Rutas internas.
* Contraseñas.
* Secretos.
* Tokens.

## 503 Service Unavailable

Una dependencia indispensable no está disponible temporalmente.

---

# 8. Errores

Los errores utilizarán Problem Details.

Ejemplo:

```json
{
  "type": "https://errors.ovsa.local/inventory/insufficient-stock",
  "title": "Stock insuficiente",
  "status": 409,
  "detail": "No existe stock disponible suficiente para completar la reserva.",
  "instance": "/api/v1/stock-reservations",
  "code": "INV-STOCK-001",
  "timestamp": "2026-08-06T04:20:00Z",
  "correlationId": "ad2cb071-63e3-4346-9912-d4e60e4dd010",
  "errors": []
}
```

## Campos estándar

* `type`: identificador del tipo de problema.
* `title`: descripción corta.
* `status`: código HTTP.
* `detail`: explicación específica.
* `instance`: recurso o solicitud afectada.

## Extensiones de OVSA

* `code`: código empresarial estable.
* `timestamp`: momento del error en UTC.
* `correlationId`: identificador de trazabilidad.
* `errors`: validaciones por campo.

## Error de validación

```json
{
  "type": "https://errors.ovsa.local/common/validation-error",
  "title": "Solicitud inválida",
  "status": 422,
  "detail": "Uno o más campos no cumplen las validaciones.",
  "instance": "/api/v1/products",
  "code": "COMMON-VALIDATION-001",
  "timestamp": "2026-08-06T04:20:00Z",
  "correlationId": "ad2cb071-63e3-4346-9912-d4e60e4dd010",
  "errors": [
    {
      "field": "name",
      "message": "El nombre es obligatorio.",
      "rejectedValue": ""
    }
  ]
}
```

Los textos podrán traducirse, pero `code` deberá permanecer estable.

---

# 9. Paginación

Las colecciones grandes utilizarán paginación desde el servidor.

Solicitud:

```http
GET /api/v1/products?page=0&size=20&sort=name,asc
```

Convenciones:

* `page` comienza en cero.
* `size` tendrá valor predeterminado `20`.
* `size` tendrá máximo inicial `100`.
* `sort` utilizará `campo,dirección`.
* Las direcciones permitidas serán `asc` y `desc`.

Respuesta:

```json
{
  "content": [],
  "page": {
    "number": 0,
    "size": 20,
    "totalElements": 0,
    "totalPages": 0,
    "first": true,
    "last": true
  }
}
```

No se devolverán listas ilimitadas.

---

# 10. Filtros

Los filtros se enviarán mediante query parameters.

Ejemplo:

```http
GET /api/v1/products?status=ACTIVE&categoryId={uuid}
```

Las fechas utilizarán ISO 8601:

```http
GET /api/v1/stock-movements?from=2026-08-01T00:00:00Z&to=2026-08-06T23:59:59Z
```

No se enviarán filtros complejos como JSON dentro de un parámetro sin una justificación documentada.

---

# 11. Identificadores

Las entidades distribuidas utilizarán UUID.

Ejemplo:

```text
f7ee845d-2e95-457a-b7d6-6e21b47476e9
```

Los identificadores:

* No contendrán significado empresarial.
* No se reutilizarán.
* No se expondrán como números secuenciales globales.
* Se tratarán como cadenas en los contratos.

Los códigos empresariales como SKU o número de orden serán propiedades distintas del identificador técnico.

---

# 12. Fechas y horas

Las fechas y horas se intercambiarán en ISO 8601 y UTC.

Ejemplo:

```text
2026-08-06T04:20:00Z
```

Los contratos utilizarán:

```yaml
type: string
format: date-time
```

Las fechas sin hora utilizarán:

```text
2026-08-06
```

---

# 13. Cantidades y dinero

Las cantidades se representarán como números decimales.

Ejemplo:

```json
{
  "quantity": 12.500
}
```

No deberán utilizarse números binarios de punto flotante para cálculos empresariales en Java.

Los valores monetarios futuros deberán incluir:

* Importe.
* Moneda.

Ejemplo:

```json
{
  "amount": 15000.00,
  "currency": "CLP"
}
```

---

# 14. Campos de auditoría

Las respuestas empresariales podrán incluir:

```json
{
  "createdAt": "2026-08-06T04:20:00Z",
  "createdBy": "uuid",
  "updatedAt": "2026-08-06T04:25:00Z",
  "updatedBy": "uuid",
  "version": 0
}
```

El cliente no controlará directamente estos valores.

---

# 15. Seguridad

Las API empresariales estarán protegidas mediante bearer token JWT.

Ejemplo:

```http
Authorization: Bearer eyJ...
```

Cada microservicio validará:

* Firma.
* Expiración.
* Emisor.
* Audiencia.
* Organización.
* Roles o permisos.

El API Gateway realizará una validación inicial, pero no reemplazará la autorización dentro de cada servicio.

---

# 16. Contexto multiempresa

El servidor obtendrá `organizationId` desde el contexto autenticado.

El cliente no podrá cambiar libremente la organización enviando:

```http
X-Organization-ID: otra-organizacion
```

Cuando un superadministrador necesite operar sobre una organización específica, se diseñará una autorización explícita.

Todas las consultas deberán respetar el contexto organizacional.

---

# 17. Correlation ID

Las solicitudes utilizarán:

```http
X-Correlation-ID: uuid
```

Si el cliente no lo envía, el gateway deberá generarlo.

Todos los servicios deberán:

* Propagarlo.
* Incluirlo en los logs.
* Agregarlo a errores.
* Devolverlo en la respuesta.

---

# 18. Idempotencia

Las operaciones críticas podrán requerir:

```http
Idempotency-Key: uuid
```

Se aplicará especialmente en:

* Confirmación de entradas.
* Confirmación de salidas.
* Reservas.
* Transferencias.
* Mermas.
* Generación de efectos empresariales irreversibles.

Si se repite la misma clave para la misma operación, el servidor no deberá duplicar el efecto.

Una clave reutilizada con un contenido diferente deberá generar conflicto.

---

# 19. Concurrencia

Los recursos modificables incluirán un número de versión.

Ejemplo:

```json
{
  "id": "uuid",
  "version": 3
}
```

Cuando dos usuarios intenten actualizar la misma versión, uno de ellos podrá recibir:

```http
409 Conflict
```

Esto evitará sobrescribir silenciosamente modificaciones recientes.

---

# 20. Operaciones asíncronas

Los procesos pesados devolverán `202 Accepted`.

Ejemplo:

```json
{
  "jobId": "uuid",
  "status": "PENDING",
  "statusUrl": "/api/v1/report-jobs/{jobId}"
}
```

El cliente consultará posteriormente:

```http
GET /api/v1/report-jobs/{jobId}
```

---

# 21. Campos desconocidos

Inicialmente, los request DTO deberán rechazar o controlar cuidadosamente propiedades no reconocidas.

Esto permite detectar errores como:

```json
{
  "nmae": "Producto escrito incorrectamente"
}
```

La política definitiva se configurará durante la implementación.

---

# 22. OpenAPI

Cada operación deberá documentar:

* `summary`.
* `operationId`.
* Tags.
* Parámetros.
* Request body.
* Respuestas exitosas.
* Respuestas de error relevantes.
* Seguridad.
* Esquemas.
* Ejemplos importantes.

Los `operationId` deberán ser únicos y utilizar camelCase.

Ejemplos:

```text
createProduct
getProductById
confirmReceipt
startWorkOrder
requestInventoryReport
```

---

# 23. Compatibilidad

Se consideran cambios generalmente compatibles:

* Agregar un endpoint.
* Agregar un campo opcional.
* Agregar un nuevo código de error documentado.
* Agregar un valor que los consumidores estén preparados para ignorar.

Se consideran cambios potencialmente incompatibles:

* Eliminar un endpoint.
* Renombrar un campo.
* Cambiar el tipo de un campo.
* Convertir un campo opcional en obligatorio.
* Eliminar un valor.
* Cambiar el significado de una respuesta.
* Cambiar una operación de síncrona a asíncrona sin migración.

---

# 24. Regla principal

La API debe expresar el lenguaje empresarial de OVSA y no la estructura interna de las tablas.

El contrato deberá mantenerse estable aunque cambien:

* Entidades JPA.
* Repositorios.
* Clases internas.
* Implementaciones técnicas.