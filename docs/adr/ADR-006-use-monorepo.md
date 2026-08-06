# Contenido de `docs/adr/ADR-006-use-monorepo.md`

# ADR-006: utilizar un monorepo inicialmente

## Estado

Accepted.

## Fecha

2026-08-03.

## Contexto

OVSA tendrá:

* Cuatro microservicios.
* Un API Gateway.
* Una aplicación web.
* Infraestructura.
* Documentación.
* Scripts.
* Pipelines.

El proyecto será desarrollado inicialmente por un desarrollador principal que está aprendiendo y construyendo todos los componentes.

Separar cada servicio en un repositorio distinto aumentaría la administración y dificultaría realizar cambios coordinados durante la fase inicial.

## Decisión

OVSA utilizará inicialmente un monorepo.

La estructura principal será:

```text
ovsa-enterprise
├── services
│   ├── identity-service
│   ├── inventory-service
│   ├── operations-service
│   └── reporting-service
├── platform
│   └── api-gateway
├── frontend
│   └── web-app
├── infrastructure
├── scripts
├── docs
└── .github
```

Aunque compartan repositorio, cada aplicación deberá mantener:

* Build independiente.
* Configuración independiente.
* Imagen Docker independiente.
* Base de datos independiente.
* Pipeline independiente.
* Despliegue independiente.
* Versionado de contrato explícito.

## Alternativas consideradas

### Repositorio por servicio

Ventajas:

* Independencia organizacional.
* Permisos por equipo.
* Historial separado.
* Pipelines simples por repositorio.

Desventajas:

* Mayor administración.
* Cambios coordinados más complejos.
* Documentación distribuida.
* Más repositorios para un equipo inicial pequeño.

### Monorepo

Ventajas:

* Visión completa del sistema.
* Documentación centralizada.
* Cambios coordinados en un pull request.
* Configuración local más sencilla.
* Reutilización controlada de pipelines y scripts.
* Facilita el aprendizaje del proyecto completo.

Desventajas:

* El repositorio crecerá.
* Los pipelines deberán detectar qué módulos cambiaron.
* Existe riesgo de crear dependencias compartidas excesivas.
* Los permisos no estarán separados por repositorio.

## Consecuencias positivas

* Será más fácil ejecutar todo el sistema localmente.
* Los documentos arquitectónicos tendrán una ubicación central.
* Los cambios de contratos podrán revisarse junto con consumidores.
* Se reducirá la administración inicial.
* El proyecto será más sencillo de estudiar.

## Consecuencias negativas

* El pipeline completo podría tardar más.
* Será necesario aplicar filtros por rutas.
* Un commit podrá afectar varios módulos.
* Se deberá evitar una gran librería compartida con todos los dominios.

## Reglas derivadas

* Cada servicio tendrá su propio archivo de construcción.
* Cada servicio tendrá sus propias migraciones.
* Cada servicio producirá su propia imagen.
* Los paquetes de dominio no se compartirán entre servicios.
* Las utilidades comunes deberán ser pequeñas y justificadas.
* Los pipelines deberán ejecutar pruebas de los módulos afectados.
* La ubicación común no permitirá acceso directo entre bases ni clases internas.

## Qué puede compartirse

Se podrá compartir de forma controlada:

* Configuración general de calidad.
* Plantillas de pipeline.
* Documentación.
* Scripts de desarrollo.
* Convenciones.
* Esquemas publicados de eventos.
* Herramientas de pruebas.

## Qué no debe compartirse directamente

No deberán compartirse como una librería común:

* Entidades de dominio.
* Entidades JPA.
* Repositorios.
* Reglas empresariales.
* DTO internos.
* Servicios de aplicación.

## Criterio de revisión

Se considerará separar repositorios cuando:

* Existan equipos independientes por servicio.
* Se requieran permisos de acceso distintos.
* Los ciclos de lanzamiento sean completamente separados.
* El tamaño del repositorio afecte seriamente el desarrollo.
* Los pipelines sean difíciles de mantener.
* Un servicio pase a ser administrado por otro equipo o proveedor.