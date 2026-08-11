# Estrategia de pruebas

## 1. Propósito

Este documento define cómo se verificará la calidad de OVSA Enterprise Operations.

La estrategia cubre:

* Dominio.
* Casos de uso.
* Persistencia.
* API.
* Seguridad.
* Mensajería.
* Contratos.
* Frontend.
* Flujos completos.
* Rendimiento.
* Recuperación.

---

# 2. Pirámide de pruebas

OVSA utilizará principalmente:

```text
                 E2E
               /     \
          Contratos
         /           \
      Integración
     /               \
    Unitarias
```

La mayor cantidad de pruebas deberá encontrarse cerca de la base.

Esto permite obtener:

* Feedback rápido.
* Menor costo de mantenimiento.
* Diagnóstico más sencillo.
* Menor dependencia de infraestructura completa.

---

# 3. Pruebas unitarias

## Objetivo

Comprobar una unidad pequeña de comportamiento de forma rápida y aislada.

Ejemplos:

* Validación de SKU.
* Cálculo de cantidades.
* Transición de estado de una orden.
* Confirmación de una entrada.
* Validación de una merma.
* Política de stock.
* Permisos empresariales.

Herramientas previstas:

* JUnit.
* AssertJ.
* Mockito cuando exista una dependencia que realmente necesite simularse.

## Regla

El dominio deberá poder probarse sin:

* MySQL.
* RabbitMQ.
* Keycloak.
* Docker.
* Servidor HTTP.

Ejemplo conceptual:

```java
@Test
void shouldNotConfirmReceiptTwice() {
    Receipt receipt = confirmedReceipt();

    assertThatThrownBy(receipt::confirm)
        .isInstanceOf(InvalidReceiptStateException.class);
}
```

Este tipo de prueba verifica una regla del negocio directamente.

---

# 4. Uso de Mockito

Mockito se utilizará para reemplazar dependencias externas en pruebas unitarias.

Ejemplo:

```text
ConfirmReceiptUseCase
        ↓
ReceiptRepository
```

En una prueba unitaria podremos simular:

```text
ReceiptRepository
```

No utilizaremos Mockito para simular cada clase del sistema.

Una prueba con demasiados mocks suele indicar un diseño demasiado acoplado.

---

# 5. Pruebas de integración

## Objetivo

Verificar que dos o más componentes reales funcionan juntos.

Ejemplos:

* Spring Data JPA + MySQL.
* Flyway + MySQL.
* Spring Boot + RabbitMQ.
* Resource Server + configuración JWT.
* Outbox + persistencia.
* Consumidor + processed_event.

Se utilizará Testcontainers para levantar dependencias reales durante las pruebas.

Ejemplos de contenedores:

```text
MySQL
RabbitMQ
Keycloak
Redis
```

---

# 6. Por qué no utilizar H2 como reemplazo automático

Una base en memoria puede comportarse diferente de MySQL.

Diferencias posibles:

* Tipos.
* Índices.
* Restricciones.
* Funciones SQL.
* Concurrencia.
* Bloqueos.
* Sintaxis.
* Ordenamientos.

Por eso, para pruebas importantes de persistencia utilizaremos MySQL real mediante contenedores.

H2 podrá utilizarse únicamente cuando exista una razón explícita.

---

# 7. Pruebas de repositorios

Se comprobarán:

* Consultas.
* Restricciones únicas.
* Filtros por organización.
* Paginación.
* Bloqueo optimista.
* Migraciones.
* Índices importantes.
* Conversión de tipos.

Ejemplo crítico:

```text
findByIdAndOrganizationId()
```

Deberá comprobar:

```text
Organización A → encuentra recurso A
Organización B → no encuentra recurso A
```

---

# 8. Pruebas de API

Se comprobarán:

* Rutas.
* Métodos HTTP.
* Request DTO.
* Response DTO.
* Códigos HTTP.
* Validaciones.
* Problem Details.
* Paginación.
* Headers.
* Correlation ID.
* Idempotency Key.
* Seguridad.

Ejemplo:

```text
POST /api/v1/products
```

Casos:

```text
201 producto creado
400 JSON inválido
401 sin token
403 sin permiso
409 SKU duplicado
422 datos empresariales inválidos
```

---

# 9. Pruebas de contrato OpenAPI

Los contratos de:

```text
docs/api
```

deberán validarse automáticamente.

Se comprobará:

* OpenAPI válido.
* Referencias válidas.
* Endpoints documentados.
* Esquemas compatibles.
* Cambios incompatibles.

El pipeline deberá fallar cuando un contrato sea inválido.

---

# 10. Pruebas de eventos

Cada evento deberá comprobar:

* `eventId`.
* `eventType`.
* `eventVersion`.
* `organizationId`.
* `aggregateId`.
* `correlationId`.
* Payload.
* Compatibilidad del esquema.

Ejemplo:

```text
inventory.receipt.confirmed.v1
```

deberá cumplir el contrato publicado.

---

# 11. Pruebas de Outbox

Se comprobarán escenarios como:

### Transacción correcta

```text
Dominio guardado
+
Outbox guardado
```

### Fallo de dominio

```text
Dominio no guardado
+
Outbox no guardado
```

### RabbitMQ temporalmente caído

```text
Operación empresarial confirmada
Outbox permanece PENDING
```

### RabbitMQ vuelve

```text
Publisher reintenta
Evento publicado
Outbox PUBLISHED
```

---

# 12. Pruebas de idempotencia

Se deberá comprobar:

```text
Mismo eventId recibido dos veces
```

Resultado:

```text
Primer mensaje → efecto aplicado
Segundo mensaje → efecto no repetido
```

También para HTTP:

```text
Misma Idempotency-Key
```

no deberá confirmar una entrada dos veces.

---

# 13. Pruebas de seguridad

Cada endpoint protegido deberá incluir casos negativos.

## Autenticación

* Sin token.
* Token vencido.
* Firma inválida.
* Issuer incorrecto.
* Audience incorrecta.

## Autorización

* Con permiso.
* Sin permiso.
* Rol insuficiente.

## Multiempresa

* Recurso propio.
* Recurso de otra empresa.
* Cambio manual de organizationId.
* Asociación cruzada entre empresas.

## Propiedades

Intentar enviar propiedades no autorizadas:

```json
{
  "roles": ["SUPER_ADMIN"]
}
```

en un request que no debería permitirlo.

---

# 14. Pruebas de frontend

Se utilizarán inicialmente:

* Pruebas unitarias de funciones.
* Pruebas de componentes.
* Pruebas de integración con API simulada cuando corresponda.
* Pruebas E2E.

Deberán probarse:

* Formularios.
* Validaciones.
* Estados de carga.
* Estados de error.
* Navegación.
* Permisos visuales.
* Paginación.
* Sesión.

El frontend no deberá duplicar las reglas empresariales del backend.

---

# 15. Pruebas E2E

Se utilizará Playwright.

Los E2E verificarán flujos importantes completos.

Flujo principal inicial:

```text
Login
  ↓
Crear producto
  ↓
Registrar entrada
  ↓
Confirmar entrada
  ↓
Consultar stock
  ↓
Crear orden
  ↓
Asignar trabajador
  ↓
Solicitar materiales
  ↓
Entregar materiales
  ↓
Completar orden
  ↓
Generar reporte
```

No intentaremos cubrir todo el sistema mediante E2E.

Los E2E son más lentos y más costosos de mantener.

---

# 16. Smoke tests

Después de un despliegue se ejecutarán pruebas rápidas.

Ejemplos:

```text
Gateway responde
Identity responde
Inventory responde
Operations responde
Reporting responde
Keycloak disponible
Bases disponibles
RabbitMQ disponible
```

También se comprobará al menos un endpoint protegido.

---

# 17. Pruebas de rendimiento

Se probarán operaciones críticas como:

* Listado de productos.
* Consulta de stock.
* Confirmación de movimientos.
* Dashboard.
* Reportes.
* Consumo de eventos.

Las pruebas permitirán encontrar:

* Consultas lentas.
* N+1.
* Índices faltantes.
* Saturación de conexiones.
* Problemas de memoria.

---

# 18. Pruebas de concurrencia

Especialmente importantes en Inventory.

Ejemplo:

```text
Stock disponible = 10
```

Dos solicitudes intentan reservar:

```text
Usuario A → 8
Usuario B → 8
```

El resultado correcto nunca podrá ser:

```text
A = 8 confirmado
B = 8 confirmado
```

si el stock inicial era 10.

Se probarán:

* Optimistic locking.
* Conflictos.
* Reintentos apropiados.
* Stock negativo.

---

# 19. Pruebas de recuperación

Se probarán fallos como:

* MySQL reiniciado.
* RabbitMQ no disponible.
* Evento enviado a DLQ.
* Servicio reiniciado.
* Reporte interrumpido.
* Backup restaurado.

El objetivo es comprobar no solamente el camino exitoso.

---

# 20. Datos de prueba

Los datos deberán:

* Ser ficticios.
* Ser reproducibles.
* Tener identificadores controlados cuando sea necesario.
* Limpiarse entre pruebas.
* No contener secretos.
* No depender de producción.

No se copiarán bases productivas directamente a desarrollo.

---

# 21. Nombres de pruebas

Los nombres deberán describir comportamiento.

Correcto:

```text
shouldRejectReceiptWhenAlreadyConfirmed
shouldReturn404WhenProductBelongsToAnotherOrganization
shouldReserveStockWhenQuantityIsAvailable
```

Evitar:

```text
test1
testProduct
works
```

---

# 22. Arrange, Act, Assert

Las pruebas seguirán cuando sea conveniente:

```text
Arrange
Act
Assert
```

Ejemplo:

```java
// Arrange
Receipt receipt = draftReceipt();

// Act
receipt.confirm();

// Assert
assertThat(receipt.status()).isEqualTo(CONFIRMED);
```

---

# 23. Cobertura

Objetivos iniciales:

```text
Dominio crítico: >= 90 %
Application: >= 80 %
Proyecto backend: >= 80 %
```

Estos porcentajes son orientativos.

Una cobertura de 100 % no garantiza un sistema correcto.

Se dará prioridad a cubrir:

* Reglas.
* Estados.
* Casos límite.
* Errores.
* Seguridad.
* Concurrencia.

---

# 24. Pipeline

El pipeline deberá ejecutar como mínimo:

```text
Compilación
    ↓
Pruebas unitarias
    ↓
Pruebas de integración
    ↓
Validación OpenAPI
    ↓
Análisis estático
    ↓
Cobertura
    ↓
Escaneo de dependencias
```

Posteriormente:

```text
Build Docker
    ↓
Staging
    ↓
Smoke tests
    ↓
E2E
```

---

# 25. Regla principal

Una prueba deberá proteger comportamiento importante y no simplemente ejecutar líneas de código.