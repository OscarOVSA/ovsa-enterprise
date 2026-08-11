# Definition of Done

## 1. Propósito

La Definition of Done establece cuándo una funcionalidad puede considerarse realmente terminada.

Una tarea no está terminada solamente porque compile o funcione en el computador del desarrollador.

---

# 2. Funcionalidad

La funcionalidad deberá:

* Cumplir sus criterios de aceptación.
* Aplicar las reglas empresariales.
* Manejar errores conocidos.
* Respetar transiciones de estado.
* Ser compatible con el alcance aprobado.

---

# 3. Código

El código deberá:

* Compilar.
* Mantener nombres según el lenguaje ubicuo.
* Respetar la arquitectura.
* No tener código muerto evidente.
* No contener secretos.
* No contener comentarios innecesarios.
* Evitar duplicación injustificada.
* Mantener funciones y clases enfocadas.

---

# 4. API

Cuando la funcionalidad exponga API:

* OpenAPI deberá actualizarse.
* Los request DTO deberán estar definidos.
* Los response DTO deberán estar definidos.
* Los códigos HTTP deberán ser correctos.
* Los errores deberán usar Problem Details.
* La paginación deberá aplicarse cuando corresponda.
* El contrato deberá validarse.

---

# 5. Persistencia

Cuando exista cambio de base de datos:

* Habrá una migración versionada.
* La migración deberá probarse.
* No se modificarán tablas manualmente.
* Los índices relevantes deberán evaluarse.
* Las restricciones empresariales deberán existir donde corresponda.
* `organization_id` deberá incluirse cuando corresponda.

---

# 6. Seguridad

La funcionalidad deberá:

* Tener permiso definido.
* Requerir autenticación cuando corresponda.
* Validar organización.
* Validar acceso al recurso.
* Evitar mass assignment.
* Tener pruebas negativas.
* Auditar acciones críticas.

---

# 7. Eventos

Cuando se publique un evento:

* El evento deberá existir en el catálogo.
* Tendrá versión.
* Tendrá contrato.
* Utilizará Outbox Pattern.
* Mantendrá correlation ID.
* No incluirá secretos.

Cuando se consuma:

* Se validará el contrato.
* Será idempotente.
* Tendrá política de errores.
* Tendrá DLQ cuando corresponda.

---

# 8. Pruebas

La funcionalidad deberá tener:

* Pruebas unitarias.
* Pruebas de integración cuando corresponda.
* Pruebas de seguridad.
* Pruebas de contrato.
* Casos de error.
* Casos límite.

Todos los tests deberán pasar.

---

# 9. Calidad

El pipeline deberá pasar:

* Build.
* Tests.
* Cobertura.
* Análisis estático.
* Validación de contratos.
* Escaneo de dependencias.
* Escaneo de secretos.

---

# 10. Observabilidad

La funcionalidad deberá:

* Generar logs útiles.
* Mantener correlation ID.
* Evitar datos sensibles.
* Exponer métricas cuando sean útiles.
* Participar en trazas cuando exista comunicación distribuida.

---

# 11. Documentación

Se deberá actualizar cuando corresponda:

* README.
* ADR.
* OpenAPI.
* Catálogo de eventos.
* Documentación de seguridad.
* Runbook.
* Manual funcional.

---

# 12. Revisión

Antes de integrar código:

* El cambio deberá estar en una rama.
* Existirá pull request.
* El diff deberá revisarse.
* El pipeline deberá estar verde.
* No deberán existir conflictos.
* Los criterios de aceptación deberán verificarse.

---

# 13. Staging

Antes de producción:

* Despliegue correcto.
* Migraciones correctas.
* Health checks correctos.
* Smoke tests correctos.
* No deberán existir errores críticos en logs.

---

# 14. Definición resumida

Una funcionalidad estará terminada cuando sea:

```text
Funcional
+
Probada
+
Segura
+
Documentada
+
Observable
+
Desplegable
```

---

# 15. Regla principal

"Funciona en mi computador" no es Definition of Done.