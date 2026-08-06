# Contratos API de OVSA

## Propósito

Esta carpeta contiene los estándares y contratos HTTP de OVSA Enterprise Operations.

Los contratos se diseñan antes de implementar los controladores para:

* Acordar rutas y operaciones.
* Definir solicitudes y respuestas.
* Establecer códigos HTTP.
* Definir reglas de seguridad.
* Evitar que el frontend dependa de detalles internos.
* Facilitar pruebas de contrato.
* Detectar cambios incompatibles.

## Archivos

| Archivo                           | Contenido                           |
| --------------------------------- | ----------------------------------- |
| `api-standards.md`                | Convenciones REST generales         |
| `common-components.yaml`          | Componentes compartidos por las API |
| `identity-service.openapi.yaml`   | Contrato de Identity Service        |
| `inventory-service.openapi.yaml`  | Contrato de Inventory Service       |
| `operations-service.openapi.yaml` | Contrato de Operations Service      |
| `reporting-service.openapi.yaml`  | Contrato de Reporting Service       |

## Versión

Los contratos iniciales utilizan OpenAPI 3.1.0.

Las rutas públicas utilizan el prefijo:

```text
/api/v1
```

## Regla principal

El contrato OpenAPI es parte de la API pública.

Modificar una ruta, propiedad, tipo de dato, código de respuesta o regla de seguridad puede afectar a los consumidores.

Los cambios incompatibles deberán introducir una nueva versión de API o un proceso de migración documentado.

## Validación

Los contratos deberán validarse antes de cada commit relacionado con API.

```powershell
npx @redocly/cli@latest lint
```

Una especificación no se considerará terminada mientras contenga errores estructurales.
