# Plantilla de historia de usuario

## ID

```text
XXX-000
```

## Título

Título breve orientado a valor.

## Epic

Nombre de la épica.

## Prioridad

```text
P0 | P1 | P2 | P3
```

## Historia

Como **[tipo de usuario]**
quiero **[capacidad]**
para **[beneficio empresarial]**.

## Contexto

Explicación adicional necesaria para comprender el problema.

## Criterios de aceptación

### Escenario 1

**Dado** que...

**Cuando**...

**Entonces**...

### Escenario 2

**Dado** que...

**Cuando**...

**Entonces**...

## Reglas empresariales

* Regla 1.
* Regla 2.

## Seguridad

Permiso requerido:

```text
resource:action
```

Validaciones:

* Autenticación.
* Organización.
* Recurso.
* Regla empresarial.

## API afectada

```text
METHOD /api/v1/resource
```

## Eventos publicados

```text
domain.resource.action.v1
```

Cuando no publique eventos:

```text
N/A
```

## Eventos consumidos

```text
domain.resource.action.v1
```

Cuando no consuma eventos:

```text
N/A
```

## Persistencia

Tablas o agregados afectados.

## Pruebas mínimas

* Caso exitoso.
* Datos inválidos.
* Sin autenticación.
* Sin permiso.
* Otra organización.
* Recurso inexistente.
* Caso límite.
* Concurrencia cuando corresponda.

## Dependencias

Historias o componentes necesarios.

## Definition of Done

Aplicar:

```text
docs/testing/definition-of-done.md
```