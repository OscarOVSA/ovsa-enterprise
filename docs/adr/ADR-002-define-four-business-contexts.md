# Contenido de `docs/adr/ADR-002-define-four-business-contexts.md`

# ADR-002: definir cuatro contextos empresariales

## Estado

Accepted.

## Fecha

2026-08-03.

## Contexto

La arquitectura de microservicios requiere límites claros.

Separar servicios por entidades técnicas produciría diseños incorrectos como:

* Product Service.
* Employee Service.
* Warehouse Service.
* Report Service.
* Role Service.

Ese enfoque puede crear demasiados servicios pequeños, comunicación excesiva y transacciones distribuidas innecesarias.

OVSA necesita separar capacidades empresariales completas y no solamente tablas individuales.

## Decisión

OVSA tendrá inicialmente cuatro bounded contexts:

### Identity

Propietario de:

* Organizaciones.
* Sucursales.
* Departamentos.
* Usuarios.
* Trabajadores.
* Roles.
* Permisos.

### Inventory

Propietario de:

* Productos.
* Proveedores.
* Bodegas.
* Ubicaciones.
* Stock.
* Entradas.
* Salidas.
* Transferencias.
* Mermas.
* Ajustes.
* Reservas.

### Operations

Propietario de:

* Centros operativos.
* Órdenes de trabajo.
* Tareas.
* Asignaciones.
* Solicitudes de materiales.
* Entregas relacionadas con trabajos.
* Devoluciones relacionadas con trabajos.
* Evidencias.

### Reporting

Propietario de:

* Dashboards.
* Reportes.
* Exportaciones.
* Auditoría.
* Alertas.
* Modelos de lectura.
* Archivos generados.

Cada contexto será implementado inicialmente mediante un microservicio.

## Alternativas consideradas

### Microservicio por entidad

Se consideró crear un servicio por producto, trabajador, bodega, orden y reporte.

Se rechazó porque:

* Generaría demasiados servicios.
* Aumentaría las llamadas de red.
* Distribuiría transacciones simples.
* Haría difícil encontrar al propietario de una regla.
* Crearía microservicios con poco comportamiento.

### Dos servicios principales

Se consideró separar solamente:

* Administración.
* Operaciones.

Se rechazó porque mezclaría identidad, inventario, trabajos y reporting dentro de límites demasiado grandes.

### Más de cuatro contextos

Se consideró separar notificaciones, auditoría, archivos y alertas como servicios adicionales.

Se rechazó inicialmente porque no existe suficiente complejidad empresarial para justificar esos servicios independientes.

Podrán extraerse en el futuro si su volumen, equipo o ciclo de cambio lo requieren.

## Consecuencias positivas

* Cada concepto tendrá un propietario definido.
* Se reducirá la duplicación de reglas.
* El número de servicios permanecerá manejable.
* Los equipos futuros podrán organizarse por dominio.
* El lenguaje ubicuo podrá mantenerse dentro de cada contexto.

## Consecuencias negativas

* Algunos servicios contendrán varios agregados.
* Será necesario diseñar cuidadosamente la comunicación entre Operations e Inventory.
* Reporting dependerá de eventos provenientes de varios contextos.
* Identity tendrá información organizacional utilizada por todos los demás servicios.

## Reglas derivadas

* Inventory será la única fuente oficial del stock.
* Identity será la única fuente oficial de organizaciones y trabajadores.
* Operations será la única fuente oficial de órdenes de trabajo.
* Reporting no modificará datos transaccionales.
* Las referencias entre contextos utilizarán identificadores.
* Un servicio no copiará una entidad completa sin una razón explícita.
* Cada nuevo concepto deberá asignarse a un único contexto propietario.

## Ejemplo

Operations podrá almacenar:

```text
employeeId
productId
warehouseId
```

Operations no será propietario de:

* Los datos personales completos del trabajador.
* La definición completa del producto.
* El saldo oficial de la bodega.

## Criterio de revisión

Los límites deberán revisarse cuando:

* Un contexto crezca demasiado.
* Un grupo de funcionalidades tenga un ciclo de cambio independiente.
* Aparezcan dependencias circulares frecuentes.
* Sea difícil identificar al propietario de una regla.
* Un servicio requiera escalarse por una capacidad interna específica.