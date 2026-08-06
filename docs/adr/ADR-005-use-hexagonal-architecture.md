# Contenido de `docs/adr/ADR-005-use-hexagonal-architecture.md`

# ADR-005: utilizar arquitectura hexagonal

## Estado

Accepted.

## Fecha

2026-08-03.

## Contexto

Cada microservicio utilizará Spring Boot, persistencia, mensajería, seguridad y clientes HTTP.

Si las reglas empresariales dependen directamente de estas tecnologías:

* El dominio será difícil de probar.
* Los controladores acumularán lógica.
* Las entidades JPA se convertirán en el modelo empresarial.
* Cambiar un detalle técnico afectará muchas clases.
* Las pruebas requerirán levantar infraestructura innecesariamente.

## Decisión

Cada microservicio utilizará una arquitectura hexagonal, organizada conceptualmente en:

* Domain.
* Application.
* Interfaces.
* Infrastructure.

## Domain

Contendrá:

* Agregados.
* Entidades.
* Value objects.
* Eventos de dominio.
* Servicios de dominio.
* Excepciones empresariales.
* Puertos necesarios por el dominio.

No dependerá de controladores, JPA, RabbitMQ ni clientes HTTP.

## Application

Contendrá:

* Casos de uso.
* Commands.
* Queries.
* Puertos de entrada.
* Puertos de salida.
* Coordinación transaccional.
* DTO internos.

Coordinará el dominio sin reemplazar sus reglas.

## Interfaces

Contendrá:

* Controladores REST.
* Request DTO.
* Response DTO.
* Validaciones HTTP.
* Manejadores globales de errores.

## Infrastructure

Contendrá:

* JPA.
* Spring Data.
* RabbitMQ.
* Clientes HTTP.
* Seguridad.
* Configuración.
* Observabilidad.
* Implementaciones de puertos.

## Dirección de dependencias

```text
Interfaces → Application → Domain
Infrastructure → Application y Domain
Domain → no depende de detalles externos
```

## Alternativas consideradas

### Arquitectura tradicional por capas

```text
controller
service
repository
entity
```

Ventajas:

* Fácil de comprender.
* Menor cantidad de interfaces.
* Adecuada para CRUD simples.

Desventajas:

* Las reglas suelen concentrarse en servicios grandes.
* El dominio puede quedar unido a JPA.
* Los casos de uso no siempre quedan explícitos.
* Es fácil que los controladores accedan directamente a repositorios.

### Clean Architecture

Tiene principios muy similares de inversión de dependencias y separación de casos de uso.

Es una alternativa válida.

Se utilizará el término arquitectura hexagonal porque expresa claramente puertos y adaptadores para persistencia, mensajería e integraciones.

## Consecuencias positivas

* Las reglas empresariales podrán probarse sin infraestructura.
* Los casos de uso serán explícitos.
* JPA no definirá el modelo completo.
* Los adaptadores podrán reemplazarse.
* Se facilitarán pruebas unitarias.
* Las dependencias tendrán una dirección controlada.

## Consecuencias negativas

* Existirán más clases e interfaces.
* Se necesitarán mappers.
* El diseño inicial será más lento que un CRUD directo.
* Una implementación exagerada podría generar abstracciones innecesarias.
* El equipo deberá comprender la dirección de dependencias.

## Reglas derivadas

* Los controladores no accederán a repositorios.
* Las entidades JPA no se devolverán desde la API.
* El dominio no utilizará anotaciones de controladores.
* No se creará una interfaz para cada clase sin necesidad.
* Los puertos existirán cuando representen una dependencia externa.
* Los casos de uso tendrán nombres empresariales.
* No se crearán carpetas vacías solamente para simular arquitectura.
* Las reglas de negocio deberán vivir cerca del dominio.

## Ejemplo correcto

```text
ReceiptController
    ↓
ConfirmReceiptUseCase
    ↓
Receipt.confirm()
    ↓
ReceiptRepository
    ↓
ReceiptPersistenceAdapter
```

## Ejemplo incorrecto

```text
ReceiptController
    ↓
ReceiptJpaRepository
    ↓
UPDATE stock_balance
```

## Criterio de revisión

La estructura podrá ajustarse si:

* Produce demasiada complejidad sin valor.
* Los paquetes no representan el dominio.
* Los casos de uso requieren otra organización.
* Se detectan dependencias circulares.
* Un servicio es principalmente de consulta y necesita una estructura distinta.