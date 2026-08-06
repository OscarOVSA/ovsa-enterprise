# Contenido de `docs/adr/ADR-003-database-per-service.md`

# ADR-003: utilizar una base de datos por servicio

## Estado

Accepted.

## Fecha

2026-08-03.

## Contexto

Los microservicios deben poder evolucionar y desplegarse independientemente.

Si varios servicios acceden directamente a las mismas tablas:

* Las estructuras internas se convierten en contratos compartidos.
* Un cambio de esquema puede romper otros servicios.
* Las reglas empresariales pueden ser ignoradas.
* La propiedad de los datos se vuelve confusa.
* Los despliegues dejan de ser independientes.

## Decisión

Cada microservicio será propietario de una base de datos lógica independiente.

Las bases iniciales serán:

```text
ovsa_identity
ovsa_inventory
ovsa_operations
ovsa_reporting
```

Cada servicio tendrá:

* Esquema independiente.
* Usuario de base de datos independiente.
* Contraseña independiente.
* Migraciones independientes.
* Permisos limitados a su propia base.
* Repositorios propios.

Durante el desarrollo local, las cuatro bases podrán ejecutarse en una misma instancia de MySQL.

Compartir una instancia física no significa compartir propiedad lógica.

## Alternativas consideradas

### Una base de datos compartida

Todos los servicios utilizarían el mismo esquema.

Ventajas:

* Consultas y joins más sencillos.
* Menor infraestructura.
* Transacciones entre módulos más fáciles.

Desventajas:

* Acoplamiento fuerte.
* Cambios de esquema peligrosos.
* Acceso directo a información ajena.
* Menor independencia.
* Dificultad para aplicar permisos técnicos.

### Una instancia física por servicio

Cada servicio tendría un servidor MySQL independiente.

Ventajas:

* Mayor aislamiento.
* Escalamiento separado.
* Fallos más independientes.

Desventajas:

* Mayor costo.
* Mayor administración.
* Mayor consumo local.
* Complejidad innecesaria durante el inicio.

### Una instancia con bases lógicas separadas

Una instancia MySQL contiene cuatro bases y usuarios separados.

Ventajas:

* Mantiene separación lógica.
* Reduce el costo inicial.
* Facilita el desarrollo local.
* Permite migrar a instancias separadas después.

Esta es la alternativa seleccionada inicialmente.

## Consecuencias positivas

* Cada servicio controla su modelo de datos.
* Las migraciones pueden ejecutarse independientemente.
* Se evita el acceso SQL entre dominios.
* Los servicios pueden cambiar internamente sin exponer tablas.
* La seguridad de base de datos puede aplicar privilegios mínimos.

## Consecuencias negativas

* No se podrán hacer joins SQL entre dominios.
* Algunas consultas requerirán modelos de lectura.
* La consistencia entre servicios será eventual.
* Las operaciones distribuidas requerirán compensaciones.
* Los datos descriptivos podrían duplicarse de forma controlada.

## Reglas derivadas

* No existirán claves foráneas entre bases de microservicios.
* No se realizarán consultas SQL entre servicios.
* Reporting construirá sus propios modelos de lectura.
* Las relaciones externas utilizarán UUID.
* Cada servicio administrará sus migraciones con una herramienta versionada.
* Los usuarios SQL tendrán privilegios únicamente sobre su base.
* Los cambios manuales en producción estarán prohibidos.

## Ejemplo incorrecto

Operations no podrá ejecutar:

```sql
SELECT *
FROM ovsa_inventory.stock_balance;
```

## Ejemplo correcto

Operations deberá:

* Invocar una API de Inventory cuando necesite respuesta inmediata.
* Consumir un evento cuando pueda utilizar consistencia eventual.
* Almacenar solamente la información mínima necesaria.

## Criterio de revisión

Esta decisión podrá revisarse si:

* Se adopta una tecnología de datos distinta para un servicio.
* Un servicio necesita aislamiento físico.
* El volumen exige instancias separadas.
* Se requiere una estrategia multi-región.
* Una regulación obliga a separar físicamente información.