# Alcance funcional

## 1. Propósito

Este documento define las capacidades que formarán parte de OVSA Enterprise Operations y establece qué funcionalidades quedarán fuera de la primera versión.

El objetivo es mantener un alcance controlado, comprobable y alineado con las necesidades empresariales principales.

---

## 2. Objetivo de la primera versión

La primera versión de OVSA permitirá administrar organizaciones, usuarios, trabajadores, productos, bodegas, inventario, órdenes de trabajo, asignaciones, materiales, reportes y auditoría.

El sistema deberá permitir completar un flujo empresarial de extremo a extremo:

1. Registrar una organización.
2. Crear usuarios y trabajadores.
3. Crear productos, proveedores y bodegas.
4. Registrar entradas de productos.
5. Consultar el stock disponible.
6. Crear una orden de trabajo.
7. Asignar trabajadores.
8. Solicitar y entregar materiales.
9. Registrar devoluciones o mermas.
10. Completar la orden de trabajo.
11. Generar reportes.
12. Consultar la auditoría.

---

## 3. Usuarios del sistema

### 3.1 Superadministrador

Responsable de administrar la plataforma completa.

Podrá:

* Crear organizaciones.
* Activar o desactivar organizaciones.
* Consultar información general de la plataforma.
* Administrar configuraciones globales.
* Consultar auditorías generales.

### 3.2 Administrador de empresa

Responsable de administrar una organización dentro de OVSA.

Podrá:

* Administrar sucursales.
* Crear usuarios.
* Crear trabajadores.
* Asignar roles y permisos.
* Consultar información de su organización.
* Configurar parámetros empresariales.

### 3.3 Jefe de bodega

Responsable del inventario y sus movimientos.

Podrá:

* Administrar productos.
* Administrar proveedores.
* Administrar bodegas y ubicaciones.
* Aprobar entradas, salidas, transferencias, ajustes y mermas.
* Consultar stock.
* Consultar trazabilidad.
* Generar reportes de inventario.

### 3.4 Operador de bodega

Responsable de ejecutar operaciones autorizadas.

Podrá:

* Registrar entradas.
* Preparar salidas.
* Registrar transferencias.
* Entregar materiales.
* Registrar devoluciones.
* Consultar stock según sus permisos.

### 3.5 Supervisor de operaciones

Responsable de planificar y controlar trabajos.

Podrá:

* Crear órdenes de trabajo.
* Asignar trabajadores.
* Crear tareas.
* Solicitar materiales.
* Revisar avances.
* Aprobar la finalización de trabajos.
* Consultar indicadores operativos.

### 3.6 Trabajador

Responsable de ejecutar las tareas asignadas.

Podrá:

* Consultar sus órdenes de trabajo.
* Consultar sus tareas.
* Registrar avances.
* Informar observaciones.
* Confirmar la recepción de materiales.
* Registrar devoluciones.

### 3.7 Auditor

Responsable de revisar operaciones y cambios.

Podrá:

* Consultar movimientos.
* Consultar actividades de usuarios.
* Consultar cambios de estado.
* Revisar reportes.
* Consultar trazabilidad.

### 3.8 Usuario de consulta

Usuario con acceso de solo lectura a información autorizada.

---

## 4. Funcionalidades incluidas

### 4.1 Administración organizacional

La primera versión incluirá:

* Organizaciones.
* Sucursales.
* Departamentos o áreas.
* Usuarios.
* Trabajadores.
* Roles.
* Permisos.
* Activación y desactivación de usuarios.
* Asociación entre usuario y trabajador.

### 4.2 Catálogo empresarial

La primera versión incluirá:

* Categorías.
* Productos.
* Unidades de medida.
* Proveedores.
* Bodegas.
* Zonas.
* Ubicaciones de almacenamiento.
* Estados de productos.
* Stock mínimo.
* Stock máximo.

### 4.3 Inventario

La primera versión incluirá:

* Entradas.
* Salidas.
* Transferencias.
* Devoluciones.
* Mermas.
* Ajustes positivos.
* Ajustes negativos.
* Reservas de stock.
* Liberación de reservas.
* Consulta de stock disponible.
* Consulta de stock reservado.
* Historial de movimientos.
* Trazabilidad por producto.
* Control de lotes cuando corresponda.

### 4.4 Operaciones

La primera versión incluirá:

* Centros o estaciones operativas.
* Tipos de trabajo.
* Órdenes de trabajo.
* Tareas.
* Prioridades.
* Estados.
* Asignación de trabajadores.
* Solicitudes de materiales.
* Entrega de materiales.
* Devolución de materiales.
* Comentarios.
* Evidencias básicas.
* Historial de estados.

### 4.5 Reportes y auditoría

La primera versión incluirá:

* Dashboard de inventario.
* Dashboard de operaciones.
* Reporte de stock.
* Reporte de movimientos.
* Reporte de entradas.
* Reporte de salidas.
* Reporte de mermas.
* Reporte por trabajador.
* Reporte por orden de trabajo.
* Exportación PDF.
* Exportación Excel.
* Registro de auditoría.
* Alertas de stock mínimo.
* Alertas de stock máximo.

### 4.6 Seguridad

La primera versión incluirá:

* Inicio de sesión.
* Tokens de acceso.
* Roles.
* Permisos.
* Restricción por organización.
* Restricción por recurso.
* Registro de acciones críticas.
* Expiración de sesión.
* Validación de autorización en backend.

---

## 5. Funcionalidades excluidas de la primera versión

Las siguientes funcionalidades no formarán parte de la primera entrega:

* Facturación electrónica.
* Contabilidad.
* Liquidación de sueldos.
* Recursos humanos completo.
* Control de asistencia.
* Gestión de contratos laborales.
* Comercio electrónico.
* Integración bancaria.
* Pagos en línea.
* Aplicación móvil nativa.
* Inteligencia artificial.
* Predicción automática de demanda.
* Compra automática a proveedores.
* Integración con ERP externos.
* Lectores físicos de códigos de barras.
* Sensores IoT.
* Geolocalización en tiempo real.
* Mantenimiento predictivo.
* Firma electrónica avanzada.
* Chat interno.
* Videollamadas.
* Gestión documental completa.

Estas capacidades podrán incorporarse en versiones futuras mediante nuevas decisiones de arquitectura y planificación.

---

## 6. Requisitos funcionales iniciales

### RF-001 — Administración de organizaciones

El sistema deberá permitir crear, consultar, actualizar, activar y desactivar organizaciones.

### RF-002 — Administración de usuarios

El sistema deberá permitir crear usuarios y asociarlos con una organización.

### RF-003 — Administración de trabajadores

El sistema deberá permitir registrar trabajadores y asociarlos con áreas, sucursales y usuarios.

### RF-004 — Control de acceso

El sistema deberá restringir las funcionalidades mediante roles y permisos.

### RF-005 — Administración de productos

El sistema deberá permitir crear, consultar, actualizar, activar y desactivar productos.

### RF-006 — Administración de proveedores

El sistema deberá permitir registrar y consultar proveedores.

### RF-007 — Administración de bodegas

El sistema deberá permitir crear bodegas, zonas y ubicaciones.

### RF-008 — Registro de entradas

El sistema deberá permitir registrar y confirmar entradas de productos.

### RF-009 — Registro de salidas

El sistema deberá permitir registrar y confirmar salidas de productos.

### RF-010 — Consulta de stock

El sistema deberá mostrar el stock disponible, reservado y dañado por producto, bodega y ubicación.

### RF-011 — Transferencias

El sistema deberá permitir transferir productos entre bodegas o ubicaciones.

### RF-012 — Mermas

El sistema deberá permitir registrar mermas indicando cantidad, motivo, responsable y evidencia cuando corresponda.

### RF-013 — Ajustes

El sistema deberá permitir realizar ajustes de inventario mediante permisos especiales.

### RF-014 — Trazabilidad

El sistema deberá permitir consultar el historial completo de movimientos de un producto.

### RF-015 — Órdenes de trabajo

El sistema deberá permitir crear, planificar, asignar, iniciar, pausar, completar y cancelar órdenes de trabajo.

### RF-016 — Asignación de trabajadores

El sistema deberá permitir asignar uno o más trabajadores a una orden de trabajo.

### RF-017 — Solicitud de materiales

El sistema deberá permitir solicitar materiales para una orden de trabajo.

### RF-018 — Reserva de materiales

El sistema deberá reservar stock antes de aprobar una entrega.

### RF-019 — Entrega de materiales

El sistema deberá registrar los materiales entregados a una orden o trabajador.

### RF-020 — Devolución de materiales

El sistema deberá registrar materiales devueltos y actualizar el inventario.

### RF-021 — Reportes

El sistema deberá generar reportes filtrados por fecha, organización, bodega, producto, trabajador y orden.

### RF-022 — Auditoría

El sistema deberá registrar las acciones empresariales relevantes realizadas por los usuarios.

### RF-023 — Alertas

El sistema deberá generar alertas cuando el stock alcance niveles mínimos o máximos.

### RF-024 — Multiempresa

El sistema deberá separar los datos de cada organización.

---

## 7. Reglas generales del alcance

* Un usuario solo podrá acceder a organizaciones autorizadas.
* Los registros confirmados no deberán eliminarse físicamente.
* Los movimientos de inventario deberán conservar trazabilidad.
* Una orden completada no podrá volver directamente al estado inicial.
* Las acciones sensibles requerirán permisos explícitos.
* Las operaciones importantes deberán registrar usuario, fecha y organización.
* Los reportes no podrán modificar información operacional.
* Cada servicio será responsable de sus propios datos.
* Ningún microservicio podrá acceder directamente a las tablas de otro servicio.

---

## 8. Criterios de éxito de la primera versión

La primera versión se considerará funcional cuando permita:

* Crear una organización.
* Crear un usuario administrador.
* Registrar trabajadores.
* Crear productos y proveedores.
* Crear una bodega.
* Registrar una entrada.
* Consultar el stock actualizado.
* Crear una orden de trabajo.
* Asignar un trabajador.
* Solicitar materiales.
* Reservar y entregar materiales.
* Registrar una devolución o merma.
* Completar la orden.
* Generar un reporte.
* Consultar la auditoría del proceso.

---

## 9. Supuestos iniciales

* La plataforma será utilizada inicialmente desde un navegador web.
* La conexión a internet estará disponible durante la operación.
* Las organizaciones tendrán usuarios previamente autorizados.
* Los productos tendrán códigos internos únicos por organización.
* Las cantidades podrán contener decimales.
* Las fechas se almacenarán en UTC.
* La interfaz inicial estará disponible en español.
* La primera implementación será desarrollada por un equipo pequeño.
* El despliegue inicial podrá utilizar contenedores Docker.
