import 'dart:convert';
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
  WebSocketChannel? _channel;
  String _estadoConexion = 'Desconectado ($disconnect / sin sesión)';
  String _ultimoMensaje = 'Ninguno';
  String _ultimaAccion = 'Ninguna';

  // URL wss:// del stage desplegado en Amazon API Gateway (dispara $connect al abrir)
  static const String _wsUrl =
      'wss://tu-api-id.execute-api.us-east-1.amazonaws.com/production';

  void _conectarWebSocket() {
    _channel?.sink.close();

    setState(() {
      _estadoConexion = 'Conectando a API Gateway ($connect)...';
    });

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));

      setState(() {
        _estadoConexion = 'Conectado en Tiempo Real (AWS wss://)';
      });

      // Escucha mensajes empujados por el backend vía PostToConnection (@connections)
      _channel!.stream.listen(
            (message) {
          String resumen = message.toString();
          try {
            final decoded = jsonDecode(resumen);
            if (decoded is Map<String, dynamic>) {
              final tipo = decoded['tipo'] ?? 'EVENTO';
              final pedidoId = decoded['pedidoId'] ?? '-';
              final estado = decoded['estado'] ?? resumen;
              resumen = '[$tipo] Pedido #$pedidoId -> $estado';
            }
          } catch (_) {}

          setState(() {
            _ultimoMensaje = resumen;
          });
        },
        onError: (error) {
          setState(() {
            _estadoConexion = 'Error de conexión wss://';
            _ultimoMensaje = 'Error: $error';
          });
        },
        onDone: () {
          setState(() {
            _estadoConexion = 'Desconectado ($disconnect)';
          });
        },
      );
    } catch (e) {
      setState(() {
        _estadoConexion = 'Error al abrir socket';
        _ultimoMensaje = 'Excepción: $e';
      });
    }
  }

  // Envía un payload JSON con "action" para que API Gateway enrute según $request.body.action
  void _enviarEventoPedido({
    required String action,
    required String pedidoId,
    required String estado,
  }) {
    if (_channel == null) {
      setState(() {
        _ultimaAccion = 'Conecta primero a AWS WebSocket para enviar "$action"';
      });
      return;
    }

    final payload = jsonEncode({
      'action': action,
      'pedidoId': pedidoId,
      'estado': estado,
      'timestamp': DateTime.now().toIso8601String(),
    });

    _channel!.sink.add(payload);
    setState(() {
      _ultimaAccion = 'Enviado ($action): $payload';
    });
  }

  void _desconectarWebSocket() {
    _channel?.sink.close();
    _channel = null;
    setState(() {
      _estadoConexion = 'Desconectado ($disconnect)';
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estaConectado = _estadoConexion.contains('Conectado');

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROYECTO FIS-PICKUP (Web - AWS RealTime)'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: estaConectado ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Último mensaje recibido (PostToConnection): $_ultimoMensaje',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 8),
              Text(
                'Último envío (\$request.body.action): $_ultimaAccion',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _conectarWebSocket,
                    icon: const Icon(Icons.cloud_sync),
                    label: const Text('Conectar con AWS WebSocket'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _enviarEventoPedido(
                      action: 'actualizarEstado',
                      pedidoId: '104',
                      estado: 'Listo para recoger',
                    ),
                    icon: const Icon(Icons.send),
                    label: const Text('Enviar estado pedido #104'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _desconectarWebSocket,
                    icon: const Icon(Icons.link_off),
                    label: const Text('Desconectar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}