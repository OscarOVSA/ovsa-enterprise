# Product Backlog

## 1. Propósito

Este documento contiene el backlog inicial priorizado de OVSA Enterprise Operations.

El backlog evolucionará durante el proyecto.

Las historias se organizan por épica y bounded context.

---

# 2. Epic PLT — Plataforma base

## PLT-001 — Crear estructura Maven multi-módulo

**Prioridad:** P0

Como desarrollador,
quiero disponer de una estructura Maven común,
para construir los servicios de OVSA de forma consistente.

### Criterios de aceptación

* Existe un `pom.xml` raíz.
* El proyecto reconoce todos los módulos backend.
* La versión de Java está centralizada.
* Las versiones comunes están administradas.
* Cada aplicación puede construirse independientemente.
* El build completo puede ejecutarse desde la raíz.

---

## PLT-002 — Crear API Gateway

**Prioridad:** P0

Como aplicación web,
quiero acceder a los servicios mediante un único punto de entrada,
para no depender directamente de las direcciones internas.

### Criterios de aceptación

* Existe API Gateway.
* Existen rutas para los cuatro microservicios.
* Las rutas son configurables por ambiente.
* El gateway propaga `X-Correlation-ID`.
* Los endpoints de salud pueden consultarse.
* Las rutas empresariales podrán protegerse mediante JWT.

---

## PLT-003 — Preparar entorno local con Docker

**Prioridad:** P0

Como desarrollador,
quiero levantar la infraestructura mediante Docker Compose,
para tener un entorno reproducible.

### Criterios de aceptación

Docker Compose podrá iniciar:

* MySQL.
* Keycloak.
* RabbitMQ.
* Redis.

Los servicios deberán utilizar:

* Health checks.
* Volúmenes cuando corresponda.
* Variables de entorno.
* Credenciales fuera del código.

---

## PLT-004 — Configurar migraciones

**Prioridad:** P0

Como desarrollador,
quiero versionar los cambios de base de datos,
para evitar modificaciones manuales de esquemas.

### Criterios de aceptación

* Flyway está configurado.
* Cada microservicio tiene sus propias migraciones.
* Las migraciones se ejecutan durante el arranque.
* Una migración fallida impide iniciar correctamente el servicio.

---

# 3. Epic SEC — Seguridad

## SEC-001 — Integrar Keycloak

**Prioridad:** P0

Como usuario,
quiero autenticarme mediante un proveedor de identidad seguro,
para acceder a OVSA sin almacenar contraseñas dentro de los microservicios.

### Criterios de aceptación

* Existe realm `ovsa`.
* Existe cliente web.
* Existe configuración para Resource Servers.
* Authorization Code con PKCE está habilitado para la aplicación web.
* Los flujos no utilizados están deshabilitados.

---

## SEC-002 — Validar JWT

**Prioridad:** P0

Como propietario de la plataforma,
quiero que cada microservicio valide sus tokens,
para impedir accesos con credenciales inválidas.

### Criterios de aceptación

Se validan:

* Firma.
* Issuer.
* Audience.
* Expiration.

Además:

* Un token inválido produce `401`.
* Un usuario sin permiso produce `403`.

---

## SEC-003 — Implementar permisos

**Prioridad:** P1

Como administrador,
quiero asignar permisos mediante roles,
para controlar las acciones disponibles para cada usuario.

### Criterios de aceptación

* Existen permisos atómicos.
* Los roles pueden agrupar permisos.
* Spring Security puede mapear permisos a authorities.
* Los endpoints pueden usar autorización por método.

---

# 4. Epic IAM — Identity

## IAM-001 — Crear organizaciones

**Prioridad:** P1

Como superadministrador,
quiero registrar organizaciones,
para incorporar empresas a OVSA.

### Criterios de aceptación

* Se puede crear organización.
* Se puede consultar.
* Se puede actualizar.
* Existe estado.
* Existe versionado optimista.
* El identificador tributario no puede duplicarse según la regla definida.
* La API cumple OpenAPI.
* Se publica `identity.organization.created.v1`.

---

## IAM-002 — Gestionar trabajadores

**Prioridad:** P1

Como administrador de empresa,
quiero registrar trabajadores,
para utilizarlos posteriormente en las operaciones.

### Criterios de aceptación

* Se puede crear trabajador.
* Se puede consultar trabajador.
* El código es único dentro de una organización.
* Existe estado activo/inactivo.
* Se respeta `organizationId`.
* Se publica `identity.employee.created.v1`.

---

## IAM-003 — Gestionar usuarios

**Prioridad:** P1

Como administrador,
quiero registrar usuarios empresariales,
para permitir acceso controlado a OVSA.

---

## IAM-004 — Gestionar roles y permisos

**Prioridad:** P1

Como administrador,
quiero asignar roles y permisos,
para controlar la autorización empresarial.

---

## IAM-005 — Crear sucursales y departamentos

**Prioridad:** P2

Como administrador,
quiero organizar trabajadores por sucursal y departamento,
para representar la estructura de la empresa.

---

# 5. Epic INV — Inventory

## INV-001 — Crear categorías

**Prioridad:** P1

Como jefe de bodega,
quiero clasificar productos,
para facilitar su administración.

---

## INV-002 — Crear productos

**Prioridad:** P1

Como jefe de bodega,
quiero registrar productos,
para controlar sus existencias.

### Criterios de aceptación

* SKU único por organización.
* Nombre obligatorio.
* Unidad de medida obligatoria.
* Stock mínimo y máximo válidos.
* Producto inicialmente activo.
* API paginada.
* OpenAPI actualizado.
* Evento `inventory.product.created.v1`.
* Pruebas de otra organización.

---

## INV-003 — Gestionar proveedores

**Prioridad:** P1

Como jefe de bodega,
quiero registrar proveedores,
para asociarlos a las entradas de productos.

---

## INV-004 — Gestionar bodegas

**Prioridad:** P1

Como jefe de bodega,
quiero crear bodegas y ubicaciones,
para conocer dónde está almacenado cada producto.

---

## INV-005 — Registrar entradas

**Prioridad:** P1

Como operador,
quiero registrar una entrada de productos,
para documentar los productos recibidos.

---

## INV-006 — Confirmar entradas

**Prioridad:** P1

Como jefe de bodega,
quiero confirmar una entrada,
para incorporar formalmente sus cantidades al stock.

### Criterios de aceptación

* Solo una entrada válida puede confirmarse.
* Se actualiza el stock.
* La operación es transaccional.
* Se guarda Outbox Event.
* Existe Idempotency Key.
* Una entrada no se confirma dos veces.
* Se publica `inventory.receipt.confirmed.v1`.

---

## INV-007 — Consultar stock

**Prioridad:** P1

Como usuario autorizado,
quiero consultar existencias,
para conocer cantidades disponibles y reservadas.

---

## INV-008 — Registrar salidas

**Prioridad:** P1

Como operador,
quiero registrar salidas,
para descontar productos entregados.

---

## INV-009 — Crear reservas

**Prioridad:** P1

Como Operations Service,
quiero reservar productos,
para impedir que materiales comprometidos sean utilizados por otra operación.

---

## INV-010 — Gestionar transferencias

**Prioridad:** P2

Como jefe de bodega,
quiero transferir productos,
para mover existencias entre ubicaciones.

---

## INV-011 — Registrar mermas

**Prioridad:** P1

Como operador,
quiero registrar productos dañados o perdidos,
para mantener el stock real.

---

## INV-012 — Ajustar stock

**Prioridad:** P2

Como jefe de bodega autorizado,
quiero realizar ajustes controlados,
para corregir diferencias justificadas.

---

## INV-013 — Consultar trazabilidad

**Prioridad:** P1

Como auditor,
quiero consultar el historial de un producto,
para reconstruir todos sus movimientos.

---

# 6. Epic OPS — Operations

## OPS-001 — Crear centros operativos

**Prioridad:** P1

Como administrador,
quiero registrar centros de operación,
para identificar dónde se realizan trabajos.

---

## OPS-002 — Crear órdenes de trabajo

**Prioridad:** P1

Como supervisor,
quiero crear órdenes de trabajo,
para planificar actividades empresariales.

---

## OPS-003 — Asignar trabajadores

**Prioridad:** P1

Como supervisor,
quiero asignar trabajadores,
para definir responsables de una orden.

---

## OPS-004 — Gestionar estados de orden

**Prioridad:** P1

Como supervisor,
quiero iniciar, pausar, reanudar y completar órdenes,
para controlar su ciclo de vida.

---

## OPS-005 — Crear solicitudes de materiales

**Prioridad:** P1

Como supervisor,
quiero solicitar materiales,
para disponer de productos necesarios para ejecutar un trabajo.

---

## OPS-006 — Integrar reservas de Inventory

**Prioridad:** P1

Como Operations Service,
quiero solicitar reservas a Inventory,
para asegurar disponibilidad antes de aprobar materiales.

---

## OPS-007 — Registrar entrega de materiales

**Prioridad:** P1

Como operador,
quiero registrar materiales entregados,
para conocer qué productos fueron destinados a una orden.

---

## OPS-008 — Registrar devoluciones

**Prioridad:** P1

Como trabajador u operador,
quiero devolver materiales no utilizados,
para reintegrarlos correctamente al inventario.

---

## OPS-009 — Adjuntar evidencias

**Prioridad:** P2

Como trabajador,
quiero adjuntar evidencia,
para demostrar la ejecución del trabajo.

---

# 7. Epic REP — Reporting

## REP-001 — Consumir eventos

**Prioridad:** P1

Como Reporting Service,
quiero consumir eventos de los otros dominios,
para construir modelos de lectura propios.

---

## REP-002 — Registrar auditoría

**Prioridad:** P1

Como auditor,
quiero consultar acciones relevantes,
para conocer quién realizó cada operación.

---

## REP-003 — Dashboard de inventario

**Prioridad:** P1

Como jefe de bodega,
quiero ver indicadores de inventario,
para detectar situaciones que requieren atención.

---

## REP-004 — Dashboard de operaciones

**Prioridad:** P2

Como supervisor,
quiero consultar indicadores de órdenes,
para controlar el trabajo operativo.

---

## REP-005 — Generar reporte de inventario

**Prioridad:** P1

Como usuario autorizado,
quiero generar reportes de inventario,
para analizar y compartir información.

---

## REP-006 — Generar archivos PDF

**Prioridad:** P1

Como usuario,
quiero descargar reportes en PDF,
para conservar información formal.

---

## REP-007 — Generar archivos XLSX

**Prioridad:** P2

Como usuario,
quiero exportar datos a Excel,
para analizarlos externamente.

---

## REP-008 — Crear alertas de stock

**Prioridad:** P2

Como jefe de bodega,
quiero recibir alertas,
para reaccionar ante niveles críticos.

---

# 8. Epic WEB — Aplicación web

## WEB-001 — Crear proyecto React

**Prioridad:** P1

Como desarrollador,
quiero una aplicación React con TypeScript,
para implementar la interfaz de OVSA.

---

## WEB-002 — Implementar autenticación

**Prioridad:** P1

Como usuario,
quiero iniciar y cerrar sesión,
para acceder de forma segura.

---

## WEB-003 — Crear layout principal

**Prioridad:** P1

Como usuario,
quiero una navegación consistente,
para acceder a los diferentes módulos.

---

## WEB-004 — Gestión de productos

**Prioridad:** P1

Como jefe de bodega,
quiero administrar productos desde la web.

---

## WEB-005 — Gestión de inventario

**Prioridad:** P1

Como operador,
quiero registrar movimientos desde la web.

---

## WEB-006 — Gestión de órdenes

**Prioridad:** P1

Como supervisor,
quiero administrar órdenes desde la web.

---

## WEB-007 — Dashboards

**Prioridad:** P1

Como usuario autorizado,
quiero visualizar indicadores desde la página principal.

---

# 9. Epic OBS — Observabilidad

## OBS-001 — Correlation ID

**Prioridad:** P0

Como administrador técnico,
quiero seguir una solicitud entre servicios,
para investigar problemas distribuidos.

---

## OBS-002 — Health checks

**Prioridad:** P0

Como plataforma,
quiero conocer el estado de cada servicio,
para detectar indisponibilidad.

---

## OBS-003 — Métricas

**Prioridad:** P1

Como administrador técnico,
quiero recopilar métricas,
para conocer rendimiento y errores.

---

## OBS-004 — Trazas distribuidas

**Prioridad:** P1

Como administrador técnico,
quiero seguir una operación completa,
para investigar problemas entre microservicios.

---

# 10. Epic DEV — DevOps

## DEV-001 — CI backend

**Prioridad:** P0

Como equipo,
quiero validar automáticamente cada cambio,
para evitar integrar código defectuoso.

---

## DEV-002 — Validación OpenAPI

**Prioridad:** P0

Como equipo,
quiero validar contratos automáticamente,
para impedir especificaciones inválidas.

---

## DEV-003 — Construcción de imágenes Docker

**Prioridad:** P1

Como equipo,
quiero generar imágenes reproducibles,
para desplegar los servicios.

---

## DEV-004 — Staging

**Prioridad:** P2

Como equipo,
quiero disponer de un ambiente previo a producción,
para validar versiones completas.

---

# 11. Prioridad de primera versión

La primera versión empresarial priorizará:

```text
P0 → plataforma necesaria para construir
P1 → flujo empresarial completo
P2 → mejoras posteriores
P3 → evolución futura
```

El objetivo no será implementar todo el backlog antes de probar valor.

La prioridad será completar un flujo vertical de extremo a extremo.