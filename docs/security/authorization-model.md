# Contenido de `docs/security/authorization-model.md`

# Modelo de autorización

## 1. Propósito

Este documento define roles, permisos y reglas de autorización de OVSA.

El modelo combinará:

* RBAC: autorización basada en roles.
* Permisos atómicos.
* Contexto de organización.
* Autorización sobre objetos.
* Reglas empresariales.

---

## 2. Roles iniciales

### SUPER_ADMIN

Administra la plataforma completa.

### ADMIN_EMPRESA

Administra usuarios y configuración dentro de una organización.

### JEFE_BODEGA

Administra catálogo e inventario y aprueba operaciones sensibles.

### OPERADOR_BODEGA

Registra y ejecuta movimientos autorizados.

### SUPERVISOR

Administra órdenes, tareas y asignaciones.

### TRABAJADOR

Consulta y ejecuta trabajos asignados.

### AUDITOR

Consulta trazabilidad y auditoría sin modificar operaciones.

### USUARIO_CONSULTA

Acceso de solo lectura a funciones autorizadas.

---

## 3. Convención de permisos

Formato:

```text
recurso:acción
```

Ejemplos:

```text
organization:create
organization:update
user:create
role:assign
employee:view
employee:create
product:view
product:create
product:update
stock:view
stock:adjust
receipt:create
receipt:confirm
issue:create
issue:confirm
waste:create
waste:approve
work-order:view
work-order:create
work-order:assign
work-order:start
work-order:complete
report:generate
audit:view
```

---

## 4. Permisos por dominio

### Identity

```text
organization:view
organization:create
organization:update
organization:activate
organization:deactivate

user:view
user:create
user:update
user:activate
user:deactivate

employee:view
employee:create
employee:update
employee:deactivate

role:view
role:create
role:update
role:assign
permission:view
permission:assign
```

### Inventory

```text
product:view
product:create
product:update
product:activate
product:deactivate

supplier:view
supplier:create
supplier:update

warehouse:view
warehouse:create
warehouse:update

stock:view
stock:adjust
stock:traceability

receipt:view
receipt:create
receipt:update
receipt:confirm
receipt:reverse

issue:view
issue:create
issue:confirm

transfer:view
transfer:create
transfer:dispatch
transfer:receive

waste:view
waste:create
waste:approve
waste:confirm
```

### Operations

```text
work-order:view
work-order:create
work-order:update
work-order:plan
work-order:assign
work-order:start
work-order:pause
work-order:review
work-order:complete
work-order:cancel

material-request:view
material-request:create
material-request:approve
material-request:reject
material-delivery:confirm
material-return:create
```

### Reporting

```text
dashboard:view
report:view
report:generate
report:download
audit:view
alert:view
alert:acknowledge
alert:close
```

---

## 5. Matriz inicial

| Permiso               | Super Admin | Admin Empresa | Jefe Bodega | Operador | Supervisor | Trabajador | Auditor | Consulta |
| --------------------- | :---------: | :-----------: | :---------: | :------: | :--------: | :--------: | :-----: | :------: |
| `organization:create` |      Sí     |       No      |      No     |    No    |     No     |     No     |    No   |    No    |
| `user:create`         |      Sí     |       Sí      |      No     |    No    |     No     |     No     |    No   |    No    |
| `role:assign`         |      Sí     |       Sí      |      No     |    No    |     No     |     No     |    No   |    No    |
| `employee:view`       |      Sí     |       Sí      |      Sí     | Limitado |     Sí     |   Propio   |    Sí   | Limitado |
| `product:view`        |      Sí     |       Sí      |      Sí     |    Sí    |     Sí     |  Limitado  |    Sí   |    Sí    |
| `product:create`      |      Sí     |    Limitado   |      Sí     |    No    |     No     |     No     |    No   |    No    |
| `stock:view`          |      Sí     |       Sí      |      Sí     |    Sí    |     Sí     |  Limitado  |    Sí   |    Sí    |
| `stock:adjust`        |      Sí     |       No      |      Sí     |    No    |     No     |     No     |    No   |    No    |
| `receipt:create`      |      Sí     |       No      |      Sí     |    Sí    |     No     |     No     |    No   |    No    |
| `receipt:confirm`     |      Sí     |       No      |      Sí     |    No    |     No     |     No     |    No   |    No    |
| `work-order:create`   |      Sí     |    Limitado   |      No     |    No    |     Sí     |     No     |    No   |    No    |
| `work-order:assign`   |      Sí     |       No      |      No     |    No    |     Sí     |     No     |    No   |    No    |
| `work-order:start`    |      Sí     |       No      |      No     |    No    |     Sí     |  Asignada  |    No   |    No    |
| `work-order:complete` |      Sí     |       No      |      No     |    No    |     Sí     |     No     |    No   |    No    |
| `report:generate`     |      Sí     |       Sí      |      Sí     | Limitado |     Sí     |     No     |    Sí   | Limitado |
| `audit:view`          |      Sí     |    Limitado   |   Limitado  |    No    |  Limitado  |     No     |    Sí   |    No    |

La matriz inicial deberá refinarse durante las historias de usuario.

---

## 6. Denegar por defecto

Una operación será rechazada si:

* No está declarada públicamente.
* No existe autenticación válida.
* No existe permiso explícito.
* La organización no coincide.
* El recurso está fuera del alcance.
* La regla empresarial no permite la acción.

La ausencia de una regla de autorización no significa acceso permitido.

---

## 7. Autorización de endpoint

Ejemplo futuro:

```java
@PreAuthorize("hasAuthority('product:create')")
```

Esto valida la capacidad general.

No valida todavía que:

* La organización sea correcta.
* La categoría sea accesible.
* El usuario pueda operar en esa sucursal.
* La acción cumpla reglas empresariales.

---

## 8. Autorización de objeto

Toda operación que reciba un identificador deberá consultar utilizando también el contexto autorizado.

Incorrecto:

```java
repository.findById(productId);
```

Correcto conceptualmente:

```java
repository.findByIdAndOrganizationId(
    productId,
    securityContext.organizationId()
);
```

Cuando exista alcance por bodega:

```java
authorizationService.canAccessWarehouse(
    userContext,
    warehouseId
);
```

---

## 9. Autorización de propiedades

Los request DTO no deberán permitir modificar propiedades sensibles accidentalmente.

Ejemplo: un trabajador no podrá enviar:

```json
{
  "status": "ACTIVE",
  "roles": ["SUPER_ADMIN"],
  "organizationId": "otra-organizacion"
}
```

si esos campos no forman parte de la operación autorizada.

Se utilizarán DTO específicos por caso de uso.

---

## 10. Separación de funciones

Las operaciones sensibles podrán requerir separación entre quien registra y quien aprueba.

Ejemplos:

* Operador registra una merma.
* Jefe de bodega aprueba la merma.
* Operador crea una entrada.
* Jefe de bodega confirma la entrada.
* Administrador crea un rol.
* Otro administrador revisa asignaciones críticas.

La separación definitiva dependerá de los requerimientos del cliente.

---

## 11. Reautenticación

Las acciones especialmente sensibles podrán requerir autenticación reciente.

Ejemplos:

* Asignar `SUPER_ADMIN`.
* Cambiar permisos administrativos.
* Ajustar grandes cantidades de stock.
* Exportar información sensible.
* Desactivar una organización.

---

## 12. Auditoría

Se auditarán como mínimo:

* Inicio de sesión exitoso o fallido.
* Creación y desactivación de usuarios.
* Asignación y retiro de roles.
* Cambio de permisos.
* Cambios de organización.
* Confirmación o reversa de inventario.
* Ajustes.
* Mermas.
* Descargas de reportes sensibles.
* Acceso administrativo.

---

## 13. Regla principal

Un rol facilita la administración de permisos, pero la decisión final deberá considerar permiso, organización, recurso y regla empresarial.