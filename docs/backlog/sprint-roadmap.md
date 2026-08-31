# Roadmap de implementación

## Propósito

Este documento define el orden inicial en el que se construirá OVSA Enterprise Operations.

El roadmap puede ajustarse según los resultados de cada sprint.

---

# Sprint 0 — Arquitectura y preparación

Objetivo:

Definir qué construiremos antes de comenzar implementación significativa.

Entregables:

* Visión.
* Alcance.
* Bounded contexts.
* Lenguaje ubicuo.
* C4.
* ADR.
* OpenAPI inicial.
* Catálogo de eventos.
* Seguridad.
* Testing.
* Requisitos no funcionales.
* Product Backlog.

Estado:

```text
IN_PROGRESS
```

---

# Sprint 1 — Plataforma ejecutable

## Objetivo

Crear una plataforma mínima donde todos los componentes backend puedan iniciar y comunicarse de manera controlada.

## Alcance

* Java y Maven.
* Parent Maven.
* Cinco módulos backend.
* API Gateway.
* Cuatro aplicaciones Spring Boot.
* Docker Compose.
* MySQL.
* Keycloak.
* RabbitMQ.
* Redis.
* Flyway.
* JWT.
* Correlation ID.
* Actuator.
* Health checks.
* Logging estructurado.
* Pipeline CI.

## Resultado

```text
Gateway
  ↓
Identity
Inventory
Operations
Reporting
```

Todos levantados y protegidos, aunque todavía sin funcionalidades empresariales completas.

---

# Sprint 2 — Identity Service

## Objetivo

Construir la identidad empresarial.

## Alcance

* Organization.
* Employee.
* User.
* Role.
* Permission.
* Multiempresa.
* API REST.
* OpenAPI.
* Eventos.
* Outbox.
* Pruebas.

## Resultado

OVSA podrá saber:

```text
Qué organización existe
Quién trabaja allí
Quién puede entrar
Qué puede hacer
```

---

# Sprint 3 — Inventory: catálogo

## Objetivo

Crear la estructura básica de inventario.

## Alcance

* Category.
* Product.
* Supplier.
* Warehouse.
* WarehouseZone.
* StorageLocation.
* API REST.
* Seguridad.
* Pruebas.

---

# Sprint 4 — Inventory: movimientos

## Objetivo

Construir el núcleo transaccional de inventario.

## Alcance

* StockBalance.
* StockMovement.
* Receipt.
* Issue.
* Reservation.
* Waste.
* Transfer.
* Adjustment.
* Outbox.
* Idempotencia.
* Concurrencia.

Este será uno de los sprints técnicamente más importantes.

---

# Sprint 5 — Operations Service

## Objetivo

Construir el flujo operativo.

## Alcance

* OperationalSite.
* WorkOrder.
* Task.
* Assignment.
* Estados.
* MaterialRequest.
* Integración con Inventory.
* MaterialDelivery.
* MaterialReturn.

---

# Sprint 6 — Reporting Service

## Objetivo

Construir consultas empresariales consolidadas.

## Alcance

* Event Consumers.
* Processed Events.
* Read Models.
* Auditoría.
* Dashboards.
* Report Jobs.
* PDF.
* XLSX.
* Alertas.

---

# Sprint 7 — Frontend base

## Objetivo

Construir la interfaz empresarial.

## Alcance

* React.
* TypeScript.
* Vite.
* Routing.
* Login.
* Layout.
* Permisos.
* Productos.
* Trabajadores.
* Stock.
* Órdenes.

---

# Sprint 8 — Integración completa

## Objetivo

Completar el primer flujo vertical.

Flujo:

```text
Login
  ↓
Crear trabajador
  ↓
Crear producto
  ↓
Registrar entrada
  ↓
Confirmar stock
  ↓
Crear orden
  ↓
Asignar trabajador
  ↓
Solicitar materiales
  ↓
Reservar stock
  ↓
Entregar material
  ↓
Completar orden
  ↓
Generar reporte
  ↓
Consultar auditoría
```

---

# Sprint 9 — Hardening

## Objetivo

Preparar el sistema para una entrega empresarial.

## Alcance

* Seguridad.
* Rendimiento.
* E2E.
* Concurrencia.
* Recuperación.
* Backups.
* Observabilidad.
* Escaneo de vulnerabilidades.
* Mejoras UX.
* Documentación.

---

# Sprint 10 — Staging y entrega

## Objetivo

Preparar una versión desplegable.

## Alcance

* Staging.
* TLS.
* Configuración externa.
* CI/CD.
* Smoke tests.
* Runbooks.
* Backup y restauración.
* Manuales.
* Release.

---

# Principio del roadmap

Cada sprint debe dejar software utilizable o una capacidad técnica demostrable.

No acumularemos meses de desarrollo sin integración.