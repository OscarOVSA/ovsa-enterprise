# Requisitos no funcionales

## 1. Propósito

Este documento define objetivos iniciales de calidad para OVSA Enterprise Operations.

Los valores son objetivos de diseño iniciales y deberán revisarse utilizando mediciones reales y necesidades contractuales.

---

# 2. Disponibilidad

## NFR-AVAIL-001

La plataforma tendrá como objetivo inicial una disponibilidad mensual de:

```text
99.9 %
```

Este objetivo no constituye todavía un SLA contractual.

## NFR-AVAIL-002

Los microservicios deberán exponer:

* Liveness.
* Readiness.
* Health information técnica controlada.

## NFR-AVAIL-003

Un fallo de Reporting no deberá impedir operaciones principales de Inventory.

---

# 3. Rendimiento

## NFR-PERF-001

Las operaciones REST transaccionales normales deberán buscar un tiempo de respuesta:

```text
p95 <= 500 ms
```

sin contar latencias externas extraordinarias.

## NFR-PERF-002

Las consultas complejas deberán utilizar:

* Paginación.
* Índices.
* Filtros.
* Modelos de lectura cuando corresponda.

## NFR-PERF-003

Los reportes pesados se procesarán asíncronamente.

## NFR-PERF-004

No se devolverán colecciones ilimitadas.

---

# 4. Escalabilidad

## NFR-SCALE-001

Cada microservicio deberá poder escalar de manera independiente.

## NFR-SCALE-002

Los servicios deberán evitar estado de sesión local cuando impida crear múltiples réplicas.

## NFR-SCALE-003

El almacenamiento de archivos deberá estar desacoplado de una instancia concreta del servicio.

---

# 5. Recuperación

Objetivos iniciales:

```text
RPO <= 15 minutos
RTO <= 2 horas
```

## NFR-REC-001

Las bases de datos deberán tener estrategia de backup.

## NFR-REC-002

La restauración deberá probarse periódicamente.

## NFR-REC-003

Los procedimientos deberán estar documentados.

Un backup no se considerará verificado hasta probar una restauración.

---

# 6. Seguridad

## NFR-SEC-001

Todo tráfico externo no local utilizará HTTPS.

## NFR-SEC-002

Los secretos no podrán almacenarse en Git.

## NFR-SEC-003

Los servicios aplicarán privilegio mínimo.

## NFR-SEC-004

Las acciones sensibles deberán auditarse.

## NFR-SEC-005

Los datos entre organizaciones deberán permanecer aislados.

---

# 7. Consistencia

## NFR-CONS-001

Dentro de un microservicio las operaciones críticas utilizarán transacciones locales.

## NFR-CONS-002

Entre microservicios se aceptará consistencia eventual cuando corresponda.

## NFR-CONS-003

No se utilizarán transacciones distribuidas entre bases de microservicios.

## NFR-CONS-004

Las operaciones críticas distribuidas utilizarán:

* Idempotencia.
* Outbox.
* Eventos.
* Compensación cuando sea necesario.

---

# 8. Observabilidad

## NFR-OBS-001

Cada solicitud tendrá `correlationId`.

## NFR-OBS-002

Los servicios producirán logs estructurados.

## NFR-OBS-003

Se recopilarán métricas de aplicación.

## NFR-OBS-004

Las comunicaciones distribuidas deberán permitir trazabilidad.

## NFR-OBS-005

Se supervisarán:

* Errores.
* Latencia.
* Disponibilidad.
* Outbox.
* Colas.
* DLQ.
* Conexiones.
* Saturación.

---

# 9. Mantenibilidad

## NFR-MAIN-001

Cada dominio tendrá propietario claro.

## NFR-MAIN-002

Los servicios respetarán arquitectura hexagonal.

## NFR-MAIN-003

Las decisiones importantes deberán registrarse mediante ADR.

## NFR-MAIN-004

Las API y eventos estarán versionados.

## NFR-MAIN-005

Las migraciones de base de datos estarán versionadas.

---

# 10. Portabilidad

## NFR-PORT-001

Las aplicaciones backend se empaquetarán como contenedores.

## NFR-PORT-002

El desarrollo local podrá ejecutarse mediante Docker Compose.

## NFR-PORT-003

La configuración específica del ambiente se mantendrá fuera del código.

---

# 11. Usabilidad

## NFR-UX-001

La aplicación web será responsive.

## NFR-UX-002

Los formularios deberán mostrar errores comprensibles.

## NFR-UX-003

Las acciones destructivas o sensibles deberán requerir confirmación adecuada.

## NFR-UX-004

Los procesos asíncronos deberán mostrar su estado.

---

# 12. Accesibilidad

## NFR-ACC-001

La interfaz utilizará HTML semántico cuando sea posible.

## NFR-ACC-002

Los formularios tendrán etiquetas asociadas.

## NFR-ACC-003

La navegación principal deberá poder utilizarse mediante teclado.

## NFR-ACC-004

El color no será el único mecanismo para comunicar estados.

---

# 13. Compatibilidad

## NFR-COMP-001

La aplicación web soportará versiones modernas de navegadores principales.

## NFR-COMP-002

Las API mantendrán compatibilidad dentro de una misma versión pública siempre que sea posible.

---

# 14. Auditoría

## NFR-AUDIT-001

Los eventos de auditoría deberán permitir responder:

* Quién.
* Qué.
* Cuándo.
* Sobre qué recurso.
* En qué organización.
* Con qué resultado.

## NFR-AUDIT-002

Los registros históricos importantes no deberán eliminarse mediante CRUD convencional.

---

# 15. Límites iniciales

Se definirán posteriormente valores medibles para:

* Tamaño máximo de archivo.
* Máximo de registros por exportación.
* Máximo de solicitudes por minuto.
* Cantidad de conexiones.
* Retención de logs.
* Retención de auditoría.
* Retención de DLQ.

Estos límites deberán medirse antes de fijarlos arbitrariamente.

---

# 16. Regla principal

Un requisito no funcional deberá convertirse en una métrica, prueba o evidencia verificable siempre que sea posible.