# OVSA Enterprise Operations

Plataforma empresarial basada en microservicios para administrar organizaciones, usuarios, inventario, operaciones, órdenes de trabajo, reportes, auditoría y alertas.

## Estado del proyecto

El proyecto se encuentra actualmente en Sprint 0: definición funcional, arquitectura, contratos y planificación técnica.

Todavía no se han implementado los microservicios.

## Objetivo general

Construir una plataforma empresarial escalable, segura, observable y mantenible, basada en cuatro microservicios independientes.

## Microservicios planificados

1. Identity Service
2. Inventory Service
3. Operations Service
4. Reporting Service

## Componentes de plataforma

* API Gateway
* Proveedor de identidad
* Broker de mensajería
* Base de datos por servicio
* Caché
* Almacenamiento de archivos
* Monitoreo y observabilidad
* Aplicación web

## Principios iniciales

* Cada microservicio será responsable de su propio dominio.
* Cada microservicio tendrá su propia base de datos.
* Ningún servicio accederá directamente a las tablas de otro.
* La comunicación inmediata utilizará API REST.
* La integración asíncrona utilizará eventos.
* Las operaciones importantes deberán ser auditables.
* La seguridad se validará en el gateway y en cada microservicio.
* Los contratos se definirán antes de implementar las funcionalidades.
* Cada servicio podrá construirse y desplegarse independientemente.

## Estructura del repositorio

```text
services/        Microservicios empresariales
platform/        Componentes propios de plataforma
frontend/        Aplicación web
infrastructure/  Contenedores, despliegue y observabilidad
scripts/         Automatizaciones
docs/            Documentación del proyecto
```

## Tecnologías

Las tecnologías y sus versiones serán seleccionadas y justificadas durante Sprint 0.

## Ejecución

El proyecto todavía no es ejecutable. Los comandos de construcción y ejecución serán agregados durante los siguientes sprints.

## Documentación

- [Visión del producto](docs/architecture/01-product-vision.md)
- [Alcance funcional](docs/architecture/02-functional-scope.md)
- [Límites del sistema](docs/architecture/03-system-boundaries.md)
- [Dominios y bounded contexts](docs/architecture/04-domain-contexts.md)
- [Lenguaje ubicuo](docs/architecture/05-ubiquitous-language.md)
- [C4: contexto del sistema](docs/architecture/06-c4-system-context.md)
- [C4: contenedores](docs/architecture/07-c4-container-view.md)
- [C4: componentes](docs/architecture/08-c4-component-view.md)
- [Decisiones arquitectónicas](docs/adr/README.md)
- [Estándares y contratos API](docs/api/README.md)
## Autor

Oscar Valenzuela