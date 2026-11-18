# Protocolo de Validación de Sincronización en Tiempo Real (WebSockets)
**Proyecto:** TESE Pickup  
**Responsable:** Dev G (Ingeniero QA & Pruebas Multiplataforma)  
**Componentes Evaluados:** Flutter Web (KDS Cocina) $\leftrightarrow$ AWS API Gateway WebSockets $\leftrightarrow$ Flutter App (Cliente)

---

## 1. Objetivo de la Prueba
Verificar que los eventos críticos emitidos desde el panel administrativo de cafetería (KDS) se propaguen de forma bidireccional hacia todos los dispositivos móviles conectados en un tiempo inferior a **1,000 milisegundos (1 segundo)**, evitando inconsistencias de inventario o pedidos sobre productos agotados (`HU-F02`, `HU-F03`).

---

## 2. Arquitectura del Flujo Validado
1. **Emisor (Flutter Web - KDS):** El personal presiona el control de deshabilitación de platillo (1 Tap).
2. **Transporte (AWS API Gateway / Lambda):** Procesa el evento `STOCK_UPDATE` y actualiza el estado en Amazon DynamoDB / ElastiCache (Redis).
3. **Receptor (Flutter Móvil - Estudiante):** Escucha el canal activo mediante BLoC/Provider y actualiza la interfaz sin recargar la vista.

---

## 3. Matriz de Escenarios de Sincronización

| ID Prueba | Evento WebSocket | Acción en Plataforma Web (KDS) | Comportamiento Esperado en App Móvil | Latencia Máxima Permitida | Resultado |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **WS-01** | `ITEM_OUT_OF_STOCK` | Cocinero marca "Torta de Milanesa" como agotada. | El botón de agregar se bloquea visualmente en tiempo real. | $\le 1000\text{ ms}$ | `Pendiente` |
| **WS-02** | `CART_CONFLICT_ALERT` | Producto se agota mientras el alumno está en el carrito. | Se despliega un `BottomSheet` interactivo sugiriendo reemplazos (`HU-F03`). | $\le 1000\text{ ms}$ | `Pendiente` |
| **WS-03** | `ORDER_STATUS_CHANGE` | Cocina cambia comanda de *En preparación* a *Listo*. | El temporizador dinámico (`HU-F01`) se actualiza y lanza notificación Push. | $\le 1500\text{ ms}$ | `Pendiente` |
| **WS-04** | `WS_RECONNECT` | Pérdida temporal de red Wi-Fi/datos en el campus por 5s. | El cliente Flutter reconecta el socket automáticamente y sincroniza el estado actual. | $\le 3000\text{ ms}$ | `Pendiente` |

---

## 4. Estructura del Payload JSON Esperado
Para considerar válida la comunicación entre el backend de AWS y los clientes Flutter, los mensajes transmitidos deben respetar el siguiente esquema:

```json
{
  "action": "STOCK_UPDATE",
  "timestamp": "2026-11-18T11:05:00Z",
  "data": {
    "cafeteria_id": 1,
    "producto_id": 104,
    "disponible": false,
    "motivo": "Insumo agotado en barra"
  }
}
