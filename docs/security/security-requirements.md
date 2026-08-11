# Contenido de `docs/security/security-requirements.md`

# Requisitos de seguridad

## 1. Propósito

Este documento convierte el modelo de seguridad en requisitos verificables.

Cada requisito podrá relacionarse posteriormente con:

* Historia de usuario.
* Caso de prueba.
* Control técnico.
* Evidencia.
* Incidente.

---

# 2. Autenticación

## SEC-AUTH-001

OVSA deberá delegar la autenticación de usuarios a Keycloak.

## SEC-AUTH-002

Los microservicios no deberán almacenar contraseñas.

## SEC-AUTH-003

La aplicación web utilizará Authorization Code Flow con PKCE.

## SEC-AUTH-004

El Implicit Flow deberá estar deshabilitado.

## SEC-AUTH-005

No existirán client secrets dentro del frontend.

## SEC-AUTH-006

Los usuarios privilegiados deberán soportar autenticación multifactor.

## SEC-AUTH-007

Los intentos de autenticación deberán poder auditarse.

---

# 3. Tokens

## SEC-TOKEN-001

El gateway y cada microservicio deberán validar la firma del JWT.

## SEC-TOKEN-002

Cada recurso deberá validar `iss`.

## SEC-TOKEN-003

Cada recurso deberá validar `aud`.

## SEC-TOKEN-004

Los tokens expirados deberán rechazarse.

## SEC-TOKEN-005

Solo se aceptarán algoritmos configurados explícitamente.

## SEC-TOKEN-006

Los tokens no deberán registrarse en logs.

## SEC-TOKEN-007

Los tokens no deberán enviarse mediante parámetros de URL.

## SEC-TOKEN-008

Los access tokens tendrán duración limitada.

## SEC-TOKEN-009

El ID token no deberá utilizarse como access token de API.

---

# 4. Autorización

## SEC-AUTHZ-001

Todos los endpoints no públicos deberán requerir autenticación.

## SEC-AUTHZ-002

Las operaciones deberán denegarse por defecto.

## SEC-AUTHZ-003

Cada operación sensible deberá requerir un permiso explícito.

## SEC-AUTHZ-004

Cada endpoint que reciba un ID deberá aplicar autorización sobre el objeto.

## SEC-AUTHZ-005

Los DTO deberán impedir modificaciones no autorizadas de propiedades.

## SEC-AUTHZ-006

El backend no deberá confiar en controles visuales del frontend.

## SEC-AUTHZ-007

Los permisos se verificarán nuevamente dentro del microservicio.

## SEC-AUTHZ-008

Las transiciones de estado deberán validar reglas empresariales además de permisos.

---

# 5. Multiempresa

## SEC-TENANT-001

Los registros empresariales deberán incluir `organization_id`.

## SEC-TENANT-002

El contexto organizacional deberá obtenerse desde el token validado.

## SEC-TENANT-003

Las consultas deberán filtrar por ID y organización.

## SEC-TENANT-004

El cliente no podrá asignar libremente `organization_id`.

## SEC-TENANT-005

Las asociaciones deberán comprobar que los recursos pertenecen a la misma organización.

## SEC-TENANT-006

Las claves de caché incluirán la organización.

## SEC-TENANT-007

Los eventos empresariales incluirán `organizationId`.

## SEC-TENANT-008

Las pruebas deberán intentar acceso cruzado entre organizaciones.

---

# 6. Transporte y navegador

## SEC-TRANS-001

Los ambientes no locales deberán utilizar HTTPS.

## SEC-TRANS-002

CORS utilizará una lista explícita de orígenes permitidos.

## SEC-TRANS-003

El gateway deberá aplicar encabezados de seguridad.

## SEC-TRANS-004

Los tokens no se almacenarán persistentemente en el navegador.

## SEC-TRANS-005

Las respuestas sensibles deberán evitar almacenamiento en caché compartido.

---

# 7. Datos y secretos

## SEC-DATA-001

Los secretos no deberán almacenarse en Git.

## SEC-DATA-002

Cada servicio utilizará credenciales propias.

## SEC-DATA-003

Las credenciales aplicarán privilegio mínimo.

## SEC-DATA-004

Los datos sensibles no deberán exponerse en respuestas innecesarias.

## SEC-DATA-005

Los errores no deberán exponer stack traces ni consultas SQL.

## SEC-DATA-006

Las exportaciones requerirán autorización antes de descargarse.

## SEC-DATA-007

Los secretos de producción deberán poder rotarse.

---

# 8. Archivos

## SEC-FILE-001

Los archivos tendrán tamaño máximo.

## SEC-FILE-002

Los tipos permitidos estarán definidos explícitamente.

## SEC-FILE-003

El servidor generará los nombres de almacenamiento.

## SEC-FILE-004

La descarga requerirá autorización.

## SEC-FILE-005

Los archivos no se servirán como contenido ejecutable.

---

# 9. Mensajería

## SEC-MSG-001

Cada servicio tendrá credenciales propias de RabbitMQ.

## SEC-MSG-002

Los permisos del broker se limitarán a exchanges y colas necesarios.

## SEC-MSG-003

Los eventos no contendrán secretos.

## SEC-MSG-004

Los consumidores validarán el contrato recibido.

## SEC-MSG-005

Los consumidores serán idempotentes.

## SEC-MSG-006

Las DLQ deberán supervisarse.

---

# 10. Auditoría

## SEC-AUDIT-001

Las acciones sensibles deberán generar auditoría.

## SEC-AUDIT-002

La auditoría incluirá usuario, organización, acción, recurso y momento.

## SEC-AUDIT-003

Los registros de auditoría no deberán modificarse mediante API normales.

## SEC-AUDIT-004

Los cambios de roles y permisos deberán auditarse.

## SEC-AUDIT-005

Las operaciones de superadministrador deberán identificar la organización afectada.

---

# 11. Disponibilidad

## SEC-AVAIL-001

El gateway deberá aplicar rate limiting.

## SEC-AVAIL-002

Las consultas de colección utilizarán paginación.

## SEC-AVAIL-003

Las cargas de archivos tendrán límites.

## SEC-AVAIL-004

Los procesos pesados se ejecutarán de forma asíncrona.

## SEC-AVAIL-005

Los reintentos serán limitados.

## SEC-AVAIL-006

Las dependencias remotas tendrán timeout.

---

# 12. Pruebas mínimas

Cada microservicio deberá probar:

* Solicitud sin token.
* Token vencido.
* Token con firma inválida.
* Token con issuer incorrecto.
* Token con audiencia incorrecta.
* Usuario sin permiso.
* Recurso de otra organización.
* Propiedad sensible enviada en el request.
* Cambio de método HTTP.
* Transición empresarial inválida.
* Operación duplicada.
* Error sin filtración de información.

---

# 13. Definition of Done de seguridad

Una funcionalidad sensible no estará terminada hasta que:

* Tenga permiso definido.
* Valide organización.
* Valide objeto.
* Valide regla empresarial.
* Registre auditoría.
* Tenga pruebas positivas.
* Tenga pruebas negativas.
* No exponga secretos.
* Mantenga el contrato de error.
* Pase análisis automático de seguridad.