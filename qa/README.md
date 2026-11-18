# Módulo de Control de Calidad y Pruebas (QA) - TESE Pickup

Este directorio centraliza la documentación de aseguramiento de calidad, matrices de verificación, protocolos en tiempo real y scripts automatizados desarrollados por **Dev G (Ingeniero QA & Pruebas Multiplataforma)** para el repositorio `PROYECTO-FIS-PICKUP`.

---

## Estructura del Directorio

| Archivo | Tipo de Entregable | Descripción |
| :--- | :--- | :--- |
| `PLAN_DE_PRUEBAS.md` | Documentación Estratégica | Alcance, niveles de prueba, entornos y criterios de cierre (*Definition of Done*). |
| `CASOS_DE_PRUEBA.md` | Matriz de Trazabilidad | Casos de prueba funcionales (`RF01-RF08`) y no funcionales (`RNF01-RNF04`). |
| `VALIDACION_WEBSOCKETS.md` | Protocolo Tiempo Real | Escenarios de prueba y esquema JSON para sincronización KDS $\leftrightarrow$ App Móvil ($<1\text{ s}$). |
| `TESE_Pickup.postman_collection.json` | Suite Automatizada API | Peticiones HTTP y scripts de aserción en JavaScript para validar endpoints en AWS. |
| `TESE_Pickup.postman_environment.json` | Variables de Entorno | Configuración de variables (`baseUrl`, `wsUrl`, `jwtToken`) para ejecutar pruebas en Staging. |
| `load_test.js` | Script de Estrés (k6) | Simulación de concurrencia masiva (300 a 500 usuarios) en horarios de receso escolar. |

---

## Guías de Ejecución

### A. Pruebas Automatizadas de API (Postman / Newman)
1. Abrir **Postman** e importar los archivos `TESE_Pickup.postman_collection.json` y `TESE_Pickup.postman_environment.json`.
2. Seleccionar el entorno **TESE Pickup - Staging AWS** en la esquina superior derecha.
3. Ejecutar la colección mediante **Collection Runner** para validar códigos HTTP, estructura de respuesta y latencias.
4. *(Opcional vía terminal con Newman)*:
   ```bash
   newman run TESE_Pickup.postman_collection.json -e TESE_Pickup.postman_environment.json
   ```

### B. Pruebas de Carga y Concurrencia (k6)
1. Instalar k6 en el equipo local: `npm install -g k6` o mediante el instalador oficial de [k6.io](https://k6.io/).
2. Ejecutar la simulación de picos de demanda interclase:
   ```bash
   k6 run load_test.js
   ```
