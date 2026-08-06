# Contenido de `docs/adr/ADR-001-use-microservices-architecture.md`

# ADR-001: utilizar arquitectura de microservicios

## Estado

Accepted.

## Fecha

2026-08-03.

## Contexto

OVSA Enterprise Operations administrará varios procesos empresariales:

* Organizaciones.
* Usuarios y trabajadores.
* Productos y bodegas.
* Inventario.
* Órdenes de trabajo.
* Asignaciones.
* Materiales.
* Reportes.
* Auditoría.
* Alertas.

Estos procesos tienen responsabilidades, reglas, ciclos de cambio y necesidades de escalamiento diferentes.

El sistema también se utilizará como proyecto de aprendizaje profesional, por lo que deberá demostrar separación de dominios, despliegue independiente, seguridad distribuida, eventos, observabilidad y automatización.

Una aplicación monolítica tradicional sería más sencilla de construir inicialmente. Sin embargo, podría dificultar la separación real de los dominios si toda la lógica y persistencia terminan dependiendo entre sí.

## Decisión

OVSA utilizará una arquitectura de microservicios.

La primera versión estará formada por cuatro microservicios empresariales:

1. Identity Service.
2. Inventory Service.
3. Operations Service.
4. Reporting Service.

Además, utilizará componentes de plataforma como:

* API Gateway.
* Proveedor de identidad.
* Broker de mensajería.
* Bases de datos.
* Almacenamiento de archivos.
* Observabilidad.

Los componentes de plataforma no serán considerados microservicios de negocio.

## Alternativas consideradas

### Monolito tradicional

Una sola aplicación contendría todos los módulos, reglas y acceso a datos.

Ventajas:

* Menor complejidad inicial.
* Ejecución local más sencilla.
* Menos infraestructura.
* Transacciones internas simples.

Desventajas:

* Mayor riesgo de dependencias entre dominios.
* Despliegue conjunto de toda la aplicación.
* Escalamiento menos específico.
* Posible crecimiento desordenado.

### Monolito modular

Una sola aplicación ejecutable, pero dividida internamente por módulos estrictos.

Ventajas:

* Menor complejidad operativa que los microservicios.
* Buena separación si se aplican reglas arquitectónicas.
* Transacciones más sencillas.
* Desarrollo local más rápido.

Desventajas:

* Todos los módulos se despliegan juntos.
* Requiere mucha disciplina para evitar dependencias internas.
* No demuestra completamente integración distribuida.

### Microservicios

Servicios independientes organizados por capacidades empresariales.

Ventajas:

* Límites de dominio explícitos.
* Bases de datos independientes.
* Despliegue independiente.
* Escalamiento por servicio.
* Mayor aislamiento de fallos.
* Equipos futuros pueden trabajar por dominio.

Desventajas:

* Mayor complejidad de infraestructura.
* Comunicación por red.
* Consistencia distribuida.
* Mayor necesidad de observabilidad.
* Pruebas de integración más complejas.
* Desarrollo local más exigente.

## Justificación

Se seleccionan microservicios porque los cuatro dominios poseen límites empresariales identificables y se desea construir una plataforma preparada para evolución independiente.

Esta decisión no se adopta solamente por tendencia tecnológica. Se adopta porque:

* Inventory debe ser propietario exclusivo del stock.
* Operations debe evolucionar sin modificar directamente inventario.
* Reporting requiere modelos de lectura distintos.
* Identity necesita aislar información organizacional y permisos.
* Los dominios pueden escalar y desplegarse separadamente.

## Consecuencias positivas

* Los dominios tendrán propietarios claros.
* Los servicios podrán desplegarse independientemente.
* Cada servicio podrá usar modelos de datos apropiados.
* Se reducirá el acoplamiento mediante contratos.
* Será posible escalar servicios específicos.
* Se podrán aislar fallos con mayor facilidad.

## Consecuencias negativas

* Se necesitará Docker para ejecutar el entorno completo.
* Los errores distribuidos serán más difíciles de investigar.
* No existirán transacciones ACID entre servicios.
* Se deberán diseñar reintentos y compensaciones.
* Se necesitarán logs, métricas y trazas distribuidas.
* Los contratos deberán versionarse cuidadosamente.
* La configuración local será más compleja.

## Reglas derivadas

* No se crearán microservicios adicionales sin justificar un nuevo límite empresarial.
* Cada microservicio tendrá responsabilidad concreta.
* Un servicio no accederá directamente a las tablas de otro.
* Las integraciones deberán utilizar REST o eventos.
* Los servicios deberán poder construirse y desplegarse independientemente.
* La complejidad operativa deberá mantenerse bajo control.

## Criterio de revisión

Esta decisión deberá revisarse si:

* El costo operativo supera claramente el valor obtenido.
* Los límites empresariales dejan de ser independientes.
* El equipo no puede mantener la infraestructura.
* La mayoría de los cambios requiere modificar todos los servicios.
* El sistema nunca necesita despliegues ni escalamiento independiente.
