# Estrategia de pruebas de OVSA

## Propósito

Esta carpeta contiene la estrategia de calidad y pruebas de OVSA Enterprise Operations.

El objetivo no es solamente alcanzar un porcentaje de cobertura, sino comprobar que las reglas empresariales, contratos, integraciones y controles de seguridad funcionan correctamente.

## Documentos

| Documento               | Propósito                                      |
| ----------------------- | ---------------------------------------------- |
| `testing-strategy.md`   | Estrategia general de pruebas                  |
| `test-matrix.md`        | Matriz de tipos de prueba por componente       |
| `definition-of-done.md` | Criterios para considerar terminado un trabajo |

## Principios

* Las reglas empresariales críticas deberán tener pruebas automatizadas.
* Las pruebas deberán ejecutarse desde el pipeline CI.
* Las pruebas unitarias deberán ser rápidas.
* Las integraciones deberán probarse contra tecnologías reales cuando aporte valor.
* No se utilizará una base en memoria como sustituto automático de MySQL.
* Las API deberán validarse contra sus contratos.
* Los eventos deberán validar estructura y compatibilidad.
* La seguridad tendrá pruebas positivas y negativas.
* Las pruebas deberán ser deterministas.
* Una prueba no deberá depender del orden de ejecución.
* Los datos de prueba no deberán contener secretos reales.
* Las pruebas fallidas deberán impedir integrar código cuando afecten funcionalidad crítica.

## Objetivo de calidad

OVSA utilizará distintas clases de pruebas porque ningún tipo individual puede demostrar la calidad completa del sistema.

La calidad será resultado de:

* Diseño.
* Revisión.
* Pruebas.
* Automatización.
* Observabilidad.
* Seguridad.
* Documentación.