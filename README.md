# WebSockets Tiempo Real (Dev F) — FIS-PICKUP

## 1. Propósito del módulo
Mantener una canalización bidireccional persistente (`wss://`) entre los clientes (App Móvil / Web en Flutter) y el backend en AWS para notificar cambios de estado en tiempo real (por ejemplo, creación, preparación o entrega de pedidos) sin depender de consultas repetitivas (polling).

## 2. Arquitectura y flujo de eventos
1. **Conexión (`$connect`):** El cliente abre el socket hacia `wss://<api-id>.execute-api.<region>.amazonaws.com/<stage>`. API Gateway invoca la función Lambda de conexión para registrar el `connectionId` activo en DynamoDB.
2. **Mensajería (`$request.body.action`):** Los mensajes se envían en formato JSON incluyendo la clave `action` (por ejemplo, `{"action": "actualizarEstado", "pedidoId": "104", "estado": "Listo"}`). API Gateway enruta el evento a la Lambda correspondiente o a `$default`.
3. **Notificación en tiempo real (`PostToConnection`):** Cuando ocurre un evento en el backend, la Lambda consulta los `connectionId` relevantes en DynamoDB y llama a API Gateway (`@connections/{connectionId}`) para empujar el JSON al cliente conectado.
4. **Desconexión (`$disconnect`):** Al cerrar la app o perder la conexión, API Gateway dispara `$disconnect` para eliminar el `connectionId` obsoleto de DynamoDB.

## 3. Contrato de mensajes JSON (ejemplo)

### Cliente → AWS
```json
{
  "action": "actualizarEstado",
  "pedidoId": "104",
  "estado": "En preparación"
}