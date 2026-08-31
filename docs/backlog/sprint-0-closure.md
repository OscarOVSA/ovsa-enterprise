# Sprint 0 — Cierre

## Estado

COMPLETED.

## Fecha de cierre

2026-08-30.

## Objetivo

Definir la base funcional, arquitectónica y técnica de OVSA Enterprise Operations antes de comenzar la implementación.

## Resultado

Sprint 0 establece la línea base oficial de arquitectura del proyecto.

Durante este sprint se definieron:

* Visión del producto.
* Alcance funcional.
* Límites del sistema.
* Bounded contexts.
* Lenguaje ubicuo.
* Arquitectura C4.
* Decisiones arquitectónicas.
* Estándares REST.
* Contratos OpenAPI.
* Catálogo de eventos.
* Estrategia de mensajería.
* Outbox Pattern.
* Idempotencia.
* Modelo de seguridad.
* OAuth2 y OpenID Connect.
* JWT.
* Roles y permisos.
* Multi-tenancy.
* Modelo de amenazas.
* Estrategia de pruebas.
* Definition of Done.
* Requisitos no funcionales.
* Product Backlog.
* Roadmap de implementación.
* Backlog inicial de Sprint 1.

## Bounded contexts aprobados

OVSA tendrá inicialmente cuatro microservicios empresariales:

1. Identity Service.
2. Inventory Service.
3. Operations Service.
4. Reporting Service.

## Componentes de plataforma

Los siguientes componentes formarán parte de la plataforma sin considerarse microservicios empresariales:

* API Gateway.
* Keycloak.
* RabbitMQ.
* MySQL.
* Redis.
* Almacenamiento de objetos.
* Observabilidad.

## Decisiones principales

La arquitectura inicial establece:

* Microservicios organizados por capacidad empresarial.
* Base de datos por servicio.
* REST para comunicación síncrona.
* Eventos para comunicación asíncrona.
* Arquitectura hexagonal dentro de cada servicio.
* Monorepo durante la primera etapa.
* OAuth2 y OpenID Connect.
* JWT como access token.
* Autorización por permisos.
* Aislamiento mediante `organization_id`.
* Outbox Pattern para publicación confiable.
* Consumidores idempotentes.
* Contratos API y eventos versionados.

## Flujo empresarial objetivo

La primera versión deberá permitir completar:

```text
Autenticación
    ↓
Crear organización
    ↓
Registrar trabajador
    ↓
Crear producto
    ↓
Crear bodega
    ↓
Registrar entrada
    ↓
Confirmar entrada
    ↓
Consultar stock
    ↓
Crear orden de trabajo
    ↓
Asignar trabajador
    ↓
Solicitar materiales
    ↓
Reservar stock
    ↓
Entregar materiales
    ↓
Registrar devolución o merma
    ↓
Completar orden
    ↓
Generar reporte
    ↓
Consultar auditoría
```

## Requisitos para cerrar Sprint 0

La línea base debe cumplir:

| Control                       | Resultado esperado                        |
| ----------------------------- | ----------------------------------------- |
| Estructura documental         | Correcta                                  |
| Nombre OVSA                   | Consistente                               |
| Referencias a nombre anterior | Ninguna                                   |
| JSON                          | Válido                                    |
| OpenAPI                       | Válido                                    |
| Enlaces principales           | Válidos                                   |
| ADR                           | Registrados                               |
| Eventos                       | Versionados                               |
| Seguridad                     | Documentada                               |
| Testing                       | Documentado                               |
| Backlog                       | Definido                                  |
| Sprint 1                      | Planificado                               |
| Git                           | Sin cambios pendientes después del cierre |

## Riesgos conocidos

La arquitectura incorpora complejidad distribuida que deberá controlarse durante la implementación.

Los principales riesgos son:

* Sobrearquitectura.
* Dependencias síncronas excesivas.
* Fallos distribuidos.
* Consistencia eventual mal gestionada.
* Configuración incorrecta de seguridad.
* Filtración de datos entre organizaciones.
* Duplicación de eventos.
* Complejidad del entorno local.

Estos riesgos serán mitigados mediante arquitectura incremental, pruebas, observabilidad, seguridad por capas y revisión continua de las decisiones.

## Próximo sprint

Sprint 1 — Plataforma ejecutable.

El objetivo será convertir la arquitectura documental en software ejecutable mediante:

* Java.
* Maven.
* Spring Boot.
* Spring Cloud Gateway.
* Docker.
* MySQL.
* Keycloak.
* RabbitMQ.
* Flyway.
* Spring Security.
* Actuator.
* CI.

## Regla de transición

No se modificarán silenciosamente las decisiones aprobadas en Sprint 0.

Cuando una decisión arquitectónica importante cambie deberá:

1. Evaluarse.
2. Documentarse.
3. Crear o actualizar el ADR correspondiente.
4. Evaluar impacto en contratos.
5. Evaluar impacto en seguridad.
6. Evaluar impacto en consumidores.

## Conclusión

Sprint 0 establece una base suficientemente definida para comenzar la implementación sin diseñar el sistema de forma improvisada.

OVSA Enterprise Operations queda preparado para iniciar Sprint 1.