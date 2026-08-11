# Matriz de pruebas

## 1. Propósito

Este documento relaciona las áreas principales de OVSA con los tipos de pruebas que deberán utilizarse.

---

## 2. Identity Service

| Área         | Unit | Integration | Security | Contract |    E2E   |
| ------------ | :--: | :---------: | :------: | :------: | :------: |
| Organización |  Sí  |      Sí     |    Sí    |    Sí    |    Sí    |
| Usuario      |  Sí  |      Sí     |    Sí    |    Sí    |    Sí    |
| Trabajador   |  Sí  |      Sí     |    Sí    |    Sí    |    Sí    |
| Roles        |  Sí  |      Sí     |    Sí    |    Sí    | Limitado |
| Permisos     |  Sí  |      Sí     |    Sí    |    Sí    | Limitado |
| Multiempresa |  Sí  |      Sí     |    Sí    |    Sí    |    Sí    |

---

## 3. Inventory Service

| Área          | Unit | Integration | Security | Contract | Concurrency |    E2E   |
| ------------- | :--: | :---------: | :------: | :------: | :---------: | :------: |
| Producto      |  Sí  |      Sí     |    Sí    |    Sí    |      No     |    Sí    |
| Bodega        |  Sí  |      Sí     |    Sí    |    Sí    |      No     |    Sí    |
| Entrada       |  Sí  |      Sí     |    Sí    |    Sí    |      Sí     |    Sí    |
| Salida        |  Sí  |      Sí     |    Sí    |    Sí    |      Sí     |    Sí    |
| Stock         |  Sí  |      Sí     |    Sí    |    Sí    |      Sí     |    Sí    |
| Transferencia |  Sí  |      Sí     |    Sí    |    Sí    |      Sí     |    Sí    |
| Merma         |  Sí  |      Sí     |    Sí    |    Sí    |      Sí     |    Sí    |
| Reserva       |  Sí  |      Sí     |    Sí    |    Sí    |      Sí     |    Sí    |
| Outbox        |  Sí  |      Sí     |    No    |  Evento  |      Sí     | Limitado |

---

## 4. Operations Service

| Área              | Unit | Integration | Security | Contract | E2E |
| ----------------- | :--: | :---------: | :------: | :------: | :-: |
| Work Order        |  Sí  |      Sí     |    Sí    |    Sí    |  Sí |
| Task              |  Sí  |      Sí     |    Sí    |    Sí    |  Sí |
| Assignment        |  Sí  |      Sí     |    Sí    |    Sí    |  Sí |
| Material Request  |  Sí  |      Sí     |    Sí    |    Sí    |  Sí |
| Material Delivery |  Sí  |      Sí     |    Sí    |    Sí    |  Sí |
| Material Return   |  Sí  |      Sí     |    Sí    |    Sí    |  Sí |

---

## 5. Reporting Service

| Área           | Unit | Integration | Security | Contract |    E2E   |
| -------------- | :--: | :---------: | :------: | :------: | :------: |
| Dashboard      |  Sí  |      Sí     |    Sí    |    Sí    |    Sí    |
| Report Job     |  Sí  |      Sí     |    Sí    |    Sí    |    Sí    |
| PDF            |  Sí  |      Sí     |    Sí    | Limitado |    Sí    |
| XLSX           |  Sí  |      Sí     |    Sí    | Limitado |    Sí    |
| Audit          |  Sí  |      Sí     |    Sí    |    Sí    |    Sí    |
| Alert          |  Sí  |      Sí     |    Sí    |    Sí    |    Sí    |
| Event Consumer |  Sí  |      Sí     |    No    |  Evento  | Limitado |

---

## 6. API Gateway

Se deberá probar:

* Routing.
* JWT inválido.
* CORS.
* Correlation ID.
* Rate limiting.
* Respuestas de servicio no disponible.
* Propagación de headers.

---

## 7. Eventos

Todo consumidor deberá probar:

```text
Evento válido
Evento duplicado
Evento mal formado
Versión desconocida
Fallo temporal
Fallo permanente
DLQ
```

---

## 8. Multiempresa

Cada módulo con datos empresariales deberá probar:

```text
Tenant A → recurso A → permitido
Tenant A → recurso B de tenant B → denegado
Tenant B → recurso B → permitido
```

Este conjunto de pruebas será obligatorio.

---

## 9. Estados empresariales

Cada agregado con estado deberá probar todas las transiciones permitidas y prohibidas.

Ejemplo:

```text
DRAFT → CONFIRMED      permitido
CONFIRMED → DRAFT      prohibido
CONFIRMED → CONFIRMED  prohibido o idempotente según caso
```

---

## 10. Casos límite

Se probarán:

* Cero.
* Números negativos.
* Máximos.
* Campos vacíos.
* Fechas límite.
* UUID inválidos.
* Duplicados.
* Recursos inexistentes.
* Estado incorrecto.
* Concurrencia.
* Dependencias no disponibles.

---

## 11. Regla principal

Toda regla empresarial importante deberá tener al menos una prueba de éxito y una prueba de rechazo.