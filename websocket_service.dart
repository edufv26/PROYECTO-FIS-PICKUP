import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  // URL de tu API Gateway WebSocket en AWS (aquí irá tu wss:// cuando esté listo)
  final String _wsUrl = 'wss://tu-api-id.execute-api.us-east-1.amazonaws.com/production';

  // Método para conectar el dispositivo móvil al servidor de AWS en tiempo real
  void conectar() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      print("Conectado exitosamente al WebSocket de AWS desde la app móvil");

      // Escuchar las notificaciones o mensajes en tiempo real del servidor
      _channel!.stream.listen(
            (mensaje) {
          print("Mensaje recibido de AWS en móvil: $mensaje");
          // Aquí procesarás la alerta del pedido para el repartidor/usuario
        },
        onError: (error) {
          print("Error en el WebSocket móvil: $error");
        },
        onDone: () {
          print("Conexión WebSocket cerrada");
        },
      );
    } catch (e) {
      print("Excepción al intentar conectar con AWS: $e");
    }
  }

  // Método para enviar datos u órdenes hacia AWS en tiempo real
  void enviarMensaje(String mensajeJson) {
    if (_channel != null) {
      _channel!.sink.add(mensajeJson);
    } else {
      print("No hay conexión activa con AWS para enviar datos");
    }
  }

  // Desconectar el canal de forma segura
  void desconectar() {
    _channel?.sink.close();
  }
}