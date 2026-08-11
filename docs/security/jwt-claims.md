# Contenido de `docs/security/jwt-claims.md`

# Contrato de access token JWT

## 1. Propósito

Este documento define los claims que OVSA espera encontrar en un access token.

El access token será emitido por Keycloak y validado por:

* API Gateway.
* Identity Service.
* Inventory Service.
* Operations Service.
* Reporting Service.

---

## 2. Ejemplo conceptual

```json
{
  "iss": "https://auth.ovsa.cl/realms/ovsa",
  "sub": "ec6974b5-48ab-462d-857f-9149bb758261",
  "aud": [
    "ovsa-api-gateway",
    "ovsa-inventory-service"
  ],
  "exp": 1785997500,
  "iat": 1785997200,
  "nbf": 1785997200,
  "jti": "0c92e08c-a148-4246-a165-c54ec5673b18",
  "azp": "ovsa-web",
  "scope": "openid profile email",
  "organization_id": "7f51567e-4d80-443e-b4db-c16a984dd19c",
  "employee_id": "3dc579ba-416e-4ef4-bdfd-51fd3d732abb",
  "roles": [
    "JEFE_BODEGA"
  ],
  "permissions": [
    "product:create",
    "product:update",
    "stock:view",
    "receipt:confirm"
  ],
  "preferred_username": "oscar",
  "email": "oscar@example.com"
}
```

---

## 3. Claims estándar

### iss

Emisor del token.

Debe coincidir exactamente con el issuer configurado.

### sub

Identificador estable del usuario dentro del proveedor de identidad.

No se utilizará el correo como identificador principal.

### aud

Audiencia o conjunto de audiencias autorizadas para consumir el token.

Cada recurso deberá verificar que pertenece a la audiencia esperada.

### exp

Momento de expiración.

Un token expirado deberá rechazarse.

### iat

Momento de emisión.

### nbf

Momento desde el cual el token es válido.

### jti

Identificador único del token.

Podrá ayudar en auditoría y revocación cuando corresponda.

### azp

Cliente autorizado que obtuvo el token.

### scope

Alcances OAuth2 concedidos.

---

## 4. Claims empresariales

### organization_id

Identificador de la organización activa.

Será obligatorio para usuarios empresariales normales.

No deberá aceptarse desde:

* Request body.
* Query parameter.
* Header configurable por el navegador.

### employee_id

Identificador del trabajador asociado.

Será opcional porque puede existir un usuario técnico o administrativo sin trabajador asociado.

### roles

Roles empresariales efectivos del usuario.

Ejemplo:

```json
[
  "JEFE_BODEGA",
  "USUARIO_CONSULTA"
]
```

### permissions

Permisos atómicos efectivos.

Ejemplo:

```json
[
  "stock:view",
  "receipt:create",
  "receipt:confirm"
]
```

Los microservicios autorizarán preferentemente mediante permisos y no únicamente mediante nombres de rol.

---

## 5. Claims informativos

Podrán incluirse:

* `preferred_username`.
* `email`.
* `name`.

No deberán utilizarse como base única para:

* Propiedad de recursos.
* Separación multiempresa.
* Identidad técnica estable.
* Autorización sensible.

---

## 6. Claims que no deben incluirse

No deberán incluirse:

* Contraseñas.
* Client secrets.
* Información médica.
* Dirección personal.
* Datos financieros innecesarios.
* Notas internas.
* Permisos de otras organizaciones.
* Información que el consumidor no necesita.

---

## 7. Validación obligatoria

Cada Resource Server deberá validar:

```text
signature
algorithm
issuer
audience
expiration
not-before
subject
authorized party
required custom claims
```

La validación de audiencia no deberá omitirse.

No se aceptará el algoritmo indicado por el token sin compararlo con una lista autorizada.

---

## 8. Mapeo hacia Spring Security

Conceptualmente:

```text
roles       → ROLE_JEFE_BODEGA
permissions → product:create
permissions → stock:view
permissions → receipt:confirm
```

Ejemplos futuros:

```java
@PreAuthorize("hasAuthority('product:create')")
```

```java
@PreAuthorize("hasAuthority('receipt:confirm')")
```

Los prefijos de roles y permisos deberán mantenerse diferenciados.

---

## 9. Cambios de autorización

Cuando cambien roles o permisos:

* Identity actualizará la asignación empresarial.
* La información necesaria se sincronizará con Keycloak.
* Los tokens nuevos reflejarán la autorización actualizada.
* Los access tokens existentes expirarán en un periodo corto.
* Las acciones críticas podrán requerir revocación o cierre de sesión.

---

## 10. Token técnico

Un token de servicio podrá contener:

```json
{
  "sub": "service-account-ovsa-reporting-service-client",
  "azp": "ovsa-reporting-service-client",
  "client_type": "service",
  "roles": [
    "REPORTING_SERVICE"
  ],
  "permissions": [
    "object-storage:write"
  ]
}
```

No deberá inventarse un usuario humano para procesos automáticos.

---

## 11. Regla principal

Los claims deberán ser mínimos, verificables y suficientes para que el recurso tome una decisión de autorización segura.