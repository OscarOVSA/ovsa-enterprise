# Contenido de `docs/security/multi-tenancy.md`

# Aislamiento multiempresa

## 1. Propósito

Este documento define cómo OVSA separará la información de distintas organizaciones.

El objetivo principal es impedir que un usuario de una empresa consulte o modifique datos de otra.

---

## 2. Estrategia inicial

OVSA utilizará inicialmente:

```text
Shared application
Shared database instance
Separate logical databases per service
Shared tables per service
organization_id on tenant-owned records
```

Cada microservicio seguirá teniendo su base independiente, pero dentro de cada base los registros empresariales se separarán mediante `organization_id`.

---

## 3. Claim de organización

El token contendrá:

```json
{
  "organization_id": "uuid"
}
```

El backend obtendrá la organización desde el token validado.

No se confiará en un `organizationId` enviado libremente desde:

* El cuerpo.
* La URL.
* Un query parameter.
* Un encabezado controlado por el navegador.

---

## 4. Entidades con organization_id

Incluirán `organization_id`, entre otras:

### Identity

* User.
* Employee.
* Branch.
* Department.
* Role.

### Inventory

* Product.
* Supplier.
* Warehouse.
* StockBalance.
* Receipt.
* Issue.
* Transfer.
* Waste.
* StockReservation.

### Operations

* OperationalSite.
* WorkOrder.
* Assignment.
* MaterialRequest.

### Reporting

* AuditEvent.
* Alert.
* ReportJob.
* Read models.
* Dashboard snapshots.

---

## 5. Restricciones únicas

Las restricciones empresariales deberán incluir la organización.

Ejemplos:

```sql
UNIQUE (organization_id, sku)
UNIQUE (organization_id, employee_code)
UNIQUE (organization_id, warehouse_code)
UNIQUE (organization_id, work_order_code)
```

Esto permite que dos organizaciones tengan el mismo código sin compartir el mismo registro.

---

## 6. Consultas

Incorrecto:

```sql
SELECT *
FROM product
WHERE id = :productId;
```

Correcto:

```sql
SELECT *
FROM product
WHERE id = :productId
  AND organization_id = :organizationId;
```

El `organizationId` deberá provenir del contexto de seguridad.

---

## 7. Creación

El servidor asignará `organization_id`.

Incorrecto:

```json
{
  "name": "Producto",
  "organizationId": "uuid-elegido-por-el-cliente"
}
```

Correcto:

```json
{
  "name": "Producto"
}
```

La capa de aplicación agregará la organización autenticada.

---

## 8. Referencias entre recursos

Antes de asociar dos recursos se verificará que pertenezcan a la misma organización.

Ejemplo:

```text
Receipt.organizationId
Product.organizationId
Warehouse.organizationId
Supplier.organizationId
```

Todos deberán coincidir.

No bastará con comprobar que los UUID existen.

---

## 9. Superadministrador

`SUPER_ADMIN` requerirá un flujo explícito.

No deberá quedar automáticamente sin restricciones.

Cuando actúe sobre una organización:

* Deberá seleccionar un contexto autorizado.
* La operación deberá quedar auditada.
* El contexto deberá propagarse de forma controlada.
* El backend deberá validar el privilegio.
* La interfaz deberá mostrar claramente la organización activa.

No se permitirá cambiar la organización mediante un encabezado sin validación especial.

---

## 10. Usuarios con varias organizaciones

La primera versión asumirá una organización activa por sesión.

Una futura versión podrá permitir varias organizaciones mediante:

* Selección explícita.
* Emisión de un token para la organización elegida.
* Validación de membresía.
* Auditoría del cambio.
* Claims correspondientes al contexto activo.

No se enviará inicialmente una lista ilimitada de organizaciones dentro del token.

---

## 11. Eventos

Todo evento empresarial incluirá:

```text
organizationId
```

Los consumidores deberán:

* Validar que exista.
* Guardarlo en sus modelos.
* Filtrar consultas por organización.
* Evitar mezclar proyecciones de distintas empresas.

---

## 12. Caché

Toda clave de caché relacionada con información empresarial incluirá la organización.

Incorrecto:

```text
product:{productId}
```

Correcto:

```text
organization:{organizationId}:product:{productId}
```

---

## 13. Archivos

Las rutas de almacenamiento incluirán organización.

Ejemplo:

```text
organizations/{organizationId}/reports/{reportJobId}/report.pdf
```

El enlace de descarga deberá comprobar autorización antes de conceder acceso.

---

## 14. Logs y métricas

Los logs de negocio incluirán `organizationId` cuando sea apropiado.

Las métricas no deberán exponer identificadores empresariales como etiquetas de alta cardinalidad sin evaluación previa.

---

## 15. Pruebas obligatorias

Cada endpoint empresarial deberá probar al menos:

1. Acceso correcto dentro de la organización.
2. Recurso inexistente.
3. Recurso perteneciente a otra organización.
4. Usuario sin permiso.
5. Intento de cambiar `organizationId`.
6. Asociación entre recursos de organizaciones diferentes.
7. Consultas paginadas sin filtración cruzada.

---

## 16. Regla principal

Conocer el UUID de un recurso nunca debe ser suficiente para acceder a él.