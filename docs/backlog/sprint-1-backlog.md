# Sprint 1 Backlog — Plataforma ejecutable

## Objetivo del sprint

Crear la base técnica ejecutable de OVSA Enterprise Operations.

Al terminar el sprint deberán existir:

* API Gateway.
* Identity Service.
* Inventory Service.
* Operations Service.
* Reporting Service.
* Seguridad JWT.
* Infraestructura local.
* Health checks.
* Logging.
* Migraciones.
* Pipeline básico.

Todavía no se implementarán funcionalidades empresariales completas.

---

# S1-001 — Verificar herramientas

## Objetivo

Preparar el entorno de desarrollo.

## Herramientas

* Git.
* Java.
* Maven.
* Docker Desktop.
* Node.js.
* VS Code o IntelliJ IDEA.

## Criterio

Todas las herramientas deberán poder ejecutarse desde terminal.

---

# S1-002 — Crear parent Maven

Relacionado con:

```text
PLT-001
```

## Tareas

* Crear `pom.xml` raíz.
* Configurar Java.
* Configurar Spring Boot.
* Configurar Spring Cloud.
* Declarar módulos.
* Centralizar versiones.
* Configurar plugins principales.

---

# S1-003 — Crear API Gateway

Relacionado con:

```text
PLT-002
```

## Tareas

* Crear módulo.
* Agregar Spring Cloud Gateway.
* Crear clase principal.
* Crear configuración.
* Definir rutas.
* Crear health checks.
* Crear pruebas de contexto.

---

# S1-004 — Crear Identity Service base

## Tareas

* Crear módulo Spring Boot.
* Definir puerto.
* Actuator.
* Seguridad base.
* Configuración.
* Prueba de arranque.

---

# S1-005 — Crear Inventory Service base

Misma estructura base que Identity, manteniendo independencia.

---

# S1-006 — Crear Operations Service base

Misma estructura base que los servicios anteriores.

---

# S1-007 — Crear Reporting Service base

Misma estructura base que los servicios anteriores.

---

# S1-008 — Crear Docker Compose

Relacionado con:

```text
PLT-003
```

## Contenedores iniciales

* MySQL.
* Keycloak.
* RabbitMQ.
* Redis.

## Criterios

* Variables mediante `.env`.
* Health checks.
* Volúmenes.
* Red privada.
* Puertos documentados.

---

# S1-009 — Crear bases independientes

Bases:

```text
ovsa_identity
ovsa_inventory
ovsa_operations
ovsa_reporting
```

Usuarios:

```text
ovsa_identity
ovsa_inventory
ovsa_operations
ovsa_reporting
```

Cada usuario deberá acceder solamente a su propia base.

---

# S1-010 — Integrar Flyway

Relacionado con:

```text
PLT-004
```

Cada servicio deberá:

* Conectarse a su base.
* Ejecutar migraciones.
* Mantener carpeta propia.
* Fallar si una migración inválida impide consistencia.

---

# S1-011 — Configurar Keycloak

Relacionado con:

```text
SEC-001
```

## Configuración

* Realm `ovsa`.
* Cliente web.
* Clientes de servicio.
* Roles iniciales.
* Claims.
* Usuarios de prueba.

---

# S1-012 — Configurar Resource Servers

Relacionado con:

```text
SEC-002
```

Cada servicio deberá validar JWT.

Casos mínimos:

```text
sin token → 401
token inválido → 401
token válido → continúa
```

---

# S1-013 — Implementar Correlation ID

Relacionado con:

```text
OBS-001
```

El gateway deberá:

* Leer `X-Correlation-ID`.
* Generarlo si no existe.
* Propagarlo.
* Devolverlo.

Los microservicios deberán incluirlo en logs.

---

# S1-014 — Configurar Actuator

Relacionado con:

```text
OBS-002
```

Cada servicio deberá exponer:

```text
/actuator/health
/actuator/health/liveness
/actuator/health/readiness
```

La información sensible deberá estar protegida.

---

# S1-015 — Configurar logs estructurados

Los logs deberán incluir:

* Timestamp.
* Nivel.
* Servicio.
* Correlation ID.
* Mensaje.
* Error seguro.

---

# S1-016 — Preparar RabbitMQ

## Objetivo

Crear infraestructura inicial para los eventos.

## Tareas

* Exchange `ovsa.domain.events`.
* Dead-letter exchange.
* Colas iniciales.
* DLQ.
* Credenciales.
* Configuración.

Todavía no será necesario publicar todos los eventos empresariales.

---

# S1-017 — Crear migraciones de infraestructura de eventos

Cada servicio productor deberá preparar:

```text
outbox_event
```

Los consumidores deberán poder preparar posteriormente:

```text
processed_event
```

---

# S1-018 — Configurar CI

Relacionado con:

```text
DEV-001
```

El pipeline deberá ejecutar:

* Checkout.
* Configuración de Java.
* Maven build.
* Unit tests.
* Validación de estructura.
* Validación OpenAPI.

---

# S1-019 — Crear Dockerfiles

Cada aplicación backend deberá producir una imagen independiente.

Requisitos:

* Multi-stage build.
* Usuario no root.
* Imagen pequeña.
* Configuración externa.

---

# S1-020 — Documentar ejecución local

El README deberá explicar:

```text
Configurar .env
Iniciar infraestructura
Construir servicios
Ejecutar plataforma
Verificar health
Detener plataforma
```

---

# Orden recomendado

Implementar Sprint 1 aproximadamente en este orden:

```text
Herramientas
    ↓
Parent Maven
    ↓
Servicios Spring Boot
    ↓
Docker Compose
    ↓
Bases y Flyway
    ↓
Keycloak
    ↓
JWT
    ↓
Gateway
    ↓
Correlation ID
    ↓
RabbitMQ
    ↓
Actuator y logs
    ↓
Dockerfiles
    ↓
CI
    ↓
Validación
```

---

# Definition of Done de Sprint 1

Sprint 1 estará terminado cuando:

```text
docker compose up
```

permita iniciar la infraestructura y los servicios puedan construirse y ejecutarse con configuración documentada.

Además:

* Los cinco módulos backend compilan.
* Los tests pasan.
* Las bases están separadas.
* Las migraciones funcionan.
* JWT funciona.
* Correlation ID funciona.
* Health checks funcionan.
* OpenAPI continúa válido.
* No existen secretos en Git.
* CI está verde.