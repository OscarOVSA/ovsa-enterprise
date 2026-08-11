# Contenido de `docs/security/authentication-clients.md`

# Autenticación y clientes OAuth2

## 1. Propósito

Este documento define los flujos de autenticación y los clientes que OVSA registrará inicialmente en Keycloak.

---

## 2. Realm

OVSA utilizará inicialmente un realm:

```text
ovsa
```

El realm contendrá:

* Usuarios autenticables.
* Clientes OAuth2.
* Sesiones.
* Políticas de credenciales.
* Roles técnicos.
* Mappers de claims.
* Configuración de seguridad.

No se creará inicialmente un realm por organización.

La separación empresarial se realizará mediante `organization_id` y las reglas multiempresa de OVSA.

---

## 3. Aplicación web

Cliente:

```text
ovsa-web
```

Tipo:

```text
public client
```

Flujo:

```text
Authorization Code Flow with PKCE
```

Configuración conceptual:

* Standard Flow habilitado.
* Implicit Flow deshabilitado.
* Direct Access Grants deshabilitado.
* Client authentication deshabilitado.
* PKCE obligatorio.
* Redirect URIs exactas.
* Web Origins restringidos.
* Sin client secret en el navegador.

Una aplicación ejecutada en el navegador no puede proteger de forma segura un client secret permanente.

---

## 4. API Gateway

Cliente o audiencia:

```text
ovsa-api-gateway
```

Responsabilidades:

* Representar la API pública de OVSA.
* Validar tokens dirigidos a la plataforma.
* Rechazar audiencias no autorizadas.
* Propagar solicitudes hacia los servicios.

El gateway funcionará principalmente como Resource Server.

---

## 5. Microservicios

Se registrarán identificadores o audiencias para:

```text
ovsa-identity-service
ovsa-inventory-service
ovsa-operations-service
ovsa-reporting-service
```

Cada servicio validará que el token esté destinado a una audiencia permitida.

---

## 6. Servicio a servicio

Cada microservicio tendrá una identidad técnica separada.

Clientes confidenciales iniciales:

```text
ovsa-identity-service-client
ovsa-inventory-service-client
ovsa-operations-service-client
ovsa-reporting-service-client
```

Los procesos sin usuario podrán utilizar:

```text
Client Credentials Grant
```

Ejemplos:

* Publicador de outbox.
* Procesamiento de reportes.
* Tareas programadas.
* Integraciones técnicas.
* Comunicación interna sin un usuario final.

Cada cliente técnico tendrá únicamente los permisos necesarios.

---

## 7. Llamadas delegadas

Cuando un microservicio deba llamar a otro actuando realmente en nombre del usuario, no deberá reenviar indiscriminadamente tokens a cualquier servicio.

La estrategia prevista será:

1. Validar si la llamada necesita identidad del usuario.
2. Obtener un token dirigido a la audiencia destino.
3. Mantener el sujeto y contexto autorizados.
4. Aplicar privilegio mínimo.
5. Propagar `correlationId`.

Para estos casos podrá utilizarse OAuth2 Token Exchange cuando se implemente la integración correspondiente.

---

## 8. Duración inicial de sesiones

Configuración inicial propuesta para evaluación:

| Elemento              |              Valor inicial |
| --------------------- | -------------------------: |
| Access token          |                  5 minutos |
| Sesión inactiva       |                 30 minutos |
| Sesión máxima         |                    8 horas |
| Sesión administrativa | Menor que la sesión normal |

Estos valores deberán revisarse según:

* Riesgo.
* Experiencia de usuario.
* Entorno.
* Sensibilidad de funciones.
* Requisitos del cliente.

---

## 9. Almacenamiento en el navegador

La aplicación web no deberá guardar access tokens o refresh tokens permanentemente en:

```text
localStorage
sessionStorage
```

La estrategia inicial será mantener los tokens en memoria.

Una recarga completa podrá requerir:

* Recuperar la sesión mediante el proveedor de identidad.
* Ejecutar nuevamente el flujo autorizado.
* Utilizar capacidades seguras de sesión OIDC.

---

## 10. Cierre de sesión

El cierre de sesión deberá:

* Finalizar la sesión local.
* Notificar al proveedor de identidad.
* Limpiar tokens en memoria.
* Evitar reutilizar información de sesión.
* Redirigir a una ruta permitida.

---

## 11. Usuarios privilegiados

Los siguientes roles deberán utilizar controles reforzados en producción:

* `SUPER_ADMIN`.
* `ADMIN_EMPRESA`.
* Administradores técnicos.
* Usuarios capaces de cambiar roles.
* Usuarios capaces de hacer ajustes de inventario.

Se deberá considerar:

* Autenticación multifactor.
* Sesiones más cortas.
* Auditoría detallada.
* Alertas de acciones sensibles.
* Restricciones administrativas.

---

## 12. Flujos prohibidos inicialmente

No se utilizarán:

* Implicit Flow.
* Contraseñas enviadas desde OVSA a los microservicios.
* Client secrets dentro del frontend.
* Tokens en parámetros de URL.
* Una cuenta técnica compartida por todos los servicios.
* Direct Access Grants para el inicio de sesión normal.
* Credenciales hardcodeadas.

---

## 13. Redirect URIs

Las redirect URIs deberán ser exactas.

Ejemplos locales:

```text
http://localhost:5173/*
```

En producción deberán utilizar HTTPS y dominios controlados.

No se configurarán comodines amplios como:

```text
*
https://*.example.com/*
```

sin una justificación y evaluación de seguridad.

---

## 14. Regla principal

Cada cliente OAuth2 representa una aplicación o servicio concreto y deberá tener únicamente los flujos, audiencias y permisos que realmente necesita.