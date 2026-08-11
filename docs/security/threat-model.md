# Contenido de `docs/security/threat-model.md`

# Modelo inicial de amenazas

## 1. Propósito

Este documento identifica amenazas principales para OVSA Enterprise Operations y los controles previstos.

El modelo deberá actualizarse cuando:

* Aparezca un nuevo componente.
* Se agregue una integración.
* Cambie el flujo de autenticación.
* Se manejen datos más sensibles.
* Se habilite una nueva superficie pública.
* Ocurra un incidente.

---

## 2. Activos protegidos

OVSA deberá proteger:

* Credenciales.
* Tokens.
* Organizaciones.
* Información de usuarios y trabajadores.
* Productos.
* Stock.
* Movimientos de inventario.
* Órdenes de trabajo.
* Reportes.
* Auditorías.
* Evidencias.
* Secretos técnicos.
* Disponibilidad de la plataforma.
* Integridad de eventos.

---

## 3. Actores de amenaza

* Usuario anónimo.
* Usuario autenticado sin permiso.
* Usuario de otra organización.
* Usuario privilegiado abusivo.
* Aplicación comprometida.
* Servicio técnico comprometido.
* Atacante externo.
* Dependencia externa comprometida.
* Error humano.
* Configuración incorrecta.

---

## 4. Superficies de ataque

* Aplicación web.
* API Gateway.
* Endpoints REST.
* Keycloak.
* Consolas administrativas.
* RabbitMQ.
* Bases de datos.
* Redis.
* MinIO.
* Pipelines CI/CD.
* Repositorio Git.
* Logs.
* Archivos exportados.
* Dependencias de terceros.

---

## 5. Análisis STRIDE

### Spoofing — suplantación

Amenazas:

* Token falsificado.
* Credenciales robadas.
* Cliente técnico comprometido.
* Sesión secuestrada.
* Uso de cuenta compartida.

Controles:

* OpenID Connect.
* Firmas asimétricas.
* Validación de issuer y audience.
* Tokens de corta duración.
* MFA para usuarios privilegiados.
* Credenciales separadas por servicio.
* Protección frente a fuerza bruta.
* Auditoría de autenticación.

### Tampering — manipulación

Amenazas:

* Modificación de solicitudes.
* Alteración de eventos.
* Cambio no autorizado de stock.
* Manipulación de reportes.
* Actualización concurrente perdida.

Controles:

* HTTPS.
* JWT firmado.
* Validación de entrada.
* DTO específicos.
* Autorización de propiedades.
* Bloqueo optimista.
* Movimientos inmutables.
* Outbox Pattern.
* Auditoría.

### Repudiation — repudio

Amenazas:

* Usuario niega haber confirmado una entrada.
* Administrador niega haber cambiado permisos.
* No se puede reconstruir una operación.

Controles:

* `userId`.
* `organizationId`.
* `correlationId`.
* Timestamps UTC.
* Auditoría inmutable.
* Eventos versionados.
* Logs centralizados.
* Registro de cambios de roles.

### Information Disclosure — divulgación

Amenazas:

* Datos de otra organización.
* Tokens en logs.
* Reportes públicos.
* Respuestas con campos sensibles.
* Errores con stack traces.
* Buckets abiertos.

Controles:

* Filtrado por organización.
* Autorización de objeto.
* DTO de respuesta.
* Enlaces temporales.
* Cifrado en tránsito.
* Gestión de secretos.
* Logs sanitizados.
* Privilegio mínimo.
* Respuestas de error seguras.

### Denial of Service — denegación

Amenazas:

* Solicitudes masivas.
* Reportes demasiado pesados.
* Archivos enormes.
* Consultas sin paginación.
* Reintentos infinitos.
* Colas saturadas.

Controles:

* Rate limiting.
* Límites de tamaño.
* Timeouts.
* Paginación.
* Circuit breakers.
* Reportes asíncronos.
* Cuotas.
* Reintentos limitados.
* DLQ.
* Métricas y alertas.

### Elevation of Privilege — elevación

Amenazas:

* Asignación de `SUPER_ADMIN`.
* Cambio de método HTTP.
* Acceso a endpoints administrativos.
* Modificación de roles desde un DTO.
* Confianza excesiva en el gateway.

Controles:

* Denegación por defecto.
* Permisos atómicos.
* Seguridad por método.
* DTO específicos.
* Validación en cada servicio.
* Separación de funciones.
* Reautenticación.
* Auditoría y alertas.

---

## 6. Amenazas específicas de API

### Acceso a objetos de otra organización

Ataque:

```text
GET /api/v1/products/{uuid-de-otra-empresa}
```

Control:

* Buscar por ID y organización.
* Devolver `404`.
* Registrar intentos anómalos.
* Probar aislamiento automáticamente.

### Mass assignment

Ataque:

```json
{
  "name": "Usuario normal",
  "roles": ["SUPER_ADMIN"],
  "organizationId": "otra-organizacion"
}
```

Control:

* Request DTO específico.
* Campos desconocidos controlados.
* Autorización por propiedad.
* No enlazar directamente entidades JPA.

### Repetición de operación

Ataque o error:

```text
Confirmar dos veces una entrada
```

Control:

* `Idempotency-Key`.
* Estado empresarial.
* Restricción persistente.
* Respuesta consistente.

### Enumeración

Ataque:

* Probar miles de UUID.
* Diferenciar recursos ajenos por respuestas.

Control:

* Autorización de objeto.
* Respuesta uniforme.
* Rate limiting.
* Monitoreo.

---

## 7. Riesgos de JWT

* Aceptar algoritmo no permitido.
* No validar audiencia.
* Aceptar issuer incorrecto.
* Usar token expirado.
* Confundir ID token con access token.
* Registrar el token.
* Guardarlo persistentemente en el navegador.
* Incluir demasiada información.
* Reutilizar tokens entre servicios no autorizados.

Controles:

* Lista cerrada de algoritmos.
* Validadores explícitos.
* Access token de corta duración.
* Audience por recurso.
* Claims mínimos.
* No registrar tokens.
* Pruebas con tokens manipulados.

---

## 8. Riesgos de archivos

Amenazas:

* Tipo falso.
* Archivo ejecutable.
* Nombre malicioso.
* Tamaño excesivo.
* Acceso sin autorización.
* Ruta predecible.
* Malware.

Controles:

* Lista de tipos permitidos.
* Tamaño máximo.
* Nombre generado por servidor.
* Almacenamiento fuera del servidor web.
* Autorización antes de descargar.
* Escaneo cuando sea necesario.
* Enlaces temporales.
* No confiar solo en la extensión.

---

## 9. Riesgos de mensajería

Amenazas:

* Productor no autorizado.
* Evento manipulado.
* Mensaje duplicado.
* Poison message.
* DLQ ignorada.
* Datos sensibles en payload.

Controles:

* Credenciales por servicio.
* Permisos sobre exchanges y colas.
* Consumidor idempotente.
* Validación de esquema.
* Reintentos limitados.
* Monitoreo de DLQ.
* Payload mínimo.

---

## 10. Riesgos de dependencias

Amenazas:

* Biblioteca vulnerable.
* Imagen Docker comprometida.
* Dependencia abandonada.
* Paquete malicioso.

Controles:

* Versiones controladas.
* Escaneo de dependencias.
* Escaneo de imágenes.
* Actualizaciones planificadas.
* Repositorios confiables.
* SBOM futura.
* Revisión de alertas.

---

## 11. Riesgo residual

Ningún control elimina completamente el riesgo.

Cada riesgo importante deberá registrar:

* Probabilidad.
* Impacto.
* Controles.
* Responsable.
* Riesgo residual.
* Fecha de revisión.