import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIS Pickup Web',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PickupHomePage(),
    );
  }
}

class PickupHomePage extends StatefulWidget {
  const PickupHomePage({super.key});

  @override
  State<PickupHomePage> createState() => _PickupHomePageState();
}

class _PickupHomePageState extends State<PickupHomePage> {
  // Variable para almacenar el canal de WebSocket
  WebSocketChannel? _channel;
  String _estadoConexion = 'Desconectado';
  String _ultimoMensaje = 'Ninguno';

  void _conectarWebSocket() {
    setState(() {
      _estadoConexion = 'Conectando a AWS...';
    });

    try {
      // ⚠️ REEMPLAZA ESTA URL con la de tu API Gateway WebSocket de AWS cuando la tengas
      const wsUrl = 'wss://tu-api-id.execute-api.us-east-1.amazonaws.com/production';

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      setState(() {
        _estadoConexion = 'Conectado en Tiempo Real (AWS)';
      });

      // Escuchar los mensajes que manda el servidor en tiempo real
      _channel!.stream.listen(
            (message) {
          setState(() {
            _ultimoMensaje = message;
          });
          print("Mensaje recibido de AWS: $message");
        },
        onError: (error) {
          setState(() {
            _estadoConexion = 'Error de conexión';
          });
          print("Error en WebSocket: $error");
        },
        onDone: () {
          setState(() {
            _estadoConexion = 'Desconectado del servidor';
          });
          print("Conexión cerrada");
        },
      );
    } catch (e) {
      setState(() {
        _estadoConexion = 'Error al conectar';
      });
      print("Excepción: $e");
    }
  }

  @override
  void dispose() {
    // Cerrar la conexión cuando se cierre la app web
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROYECTO FIS-PICKUP (Web - AWS RealTime)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Panel de Control en Tiempo Real',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Estado: $_estadoConexion',
              style: TextStyle(
                  fontSize: 16,
                  color: _estadoConexion.contains('Conectado') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Último mensaje recibido: $_ultimoMensaje',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: _conectarWebSocket,
              icon: const Icon(Icons.cloud_sync),
              label: const Text('Conectar con AWS WebSocket'),
            ),
          ],
        ),
      ),
    );
  }
}