# Contenido de `docs/security/README.md`

# Seguridad de OVSA

## Propósito

Esta carpeta contiene el modelo de seguridad de OVSA Enterprise Operations.

La documentación define:

* Autenticación.
* Autorización.
* Clientes OAuth2.
* Claims de los tokens.
* Roles y permisos.
* Aislamiento multiempresa.
* Amenazas principales.
* Requisitos obligatorios.
* Pruebas de seguridad.

## Documentos

| Documento                   | Contenido                                 |
| --------------------------- | ----------------------------------------- |
| `security-model.md`         | Arquitectura general de seguridad         |
| `authentication-clients.md` | Flujos OAuth2 y clientes de Keycloak      |
| `jwt-claims.md`             | Contrato de access tokens                 |
| `authorization-model.md`    | Roles, permisos y niveles de autorización |
| `multi-tenancy.md`          | Separación de datos por organización      |
| `threat-model.md`           | Amenazas y controles                      |
| `security-requirements.md`  | Requisitos verificables                   |

## Principios

* Denegar acceso por defecto.
* Aplicar privilegio mínimo.
* No confiar en el frontend.
* Validar seguridad en cada microservicio.
* Separar autenticación y autorización.
* No almacenar contraseñas en las bases empresariales.
* No guardar secretos en Git.
* No registrar tokens ni contraseñas en logs.
* Validar permisos sobre la función y sobre el recurso.
* Obtener la organización desde el contexto autenticado.
* Auditar las acciones sensibles.
* Utilizar HTTPS fuera del entorno local.
* Mantener tokens con duración limitada.
* Rotar credenciales y claves.
* Automatizar las pruebas de seguridad.

## Regla principal

Un token válido demuestra una identidad autenticada, pero no concede automáticamente acceso a todos los recursos.

Cada operación debe validar:

1. Identidad.
2. Permiso.
3. Organización.
4. Propiedad o alcance del recurso.
5. Estado y reglas empresariales.