import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/platillo.dart';
import '../models/pedido.dart';
import '../services/aws_api_service.dart';

class CafeteriaProvider extends ChangeNotifier {
  final AwsApiService _api = AwsApiService();

  WebSocketChannel? _wsChannel;
  bool _wsConectado = false;
  String _ultimoEventoWs = 'Sin eventos recientes';

  bool get wsConectado => _wsConectado;
  String get ultimoEventoWs => _ultimoEventoWs;

  List<Platillo> _menu = [];
  List<Pedido> _pedidos = [];

  List<Platillo> get menu => _menu;

  List<Pedido> obtenerPedidosPorEstado(EstadoPedido estado) {
    final lista = _pedidos.where((p) => p.estado == estado).toList();
    // Orden cronológico para evitar saturación en horas pico
    lista.sort((a, b) => a.horaPedido.compareTo(b.horaPedido));
    return lista;
  }

  Future<void> cargarDatos(String cafeteriaId) async {
    try {
      _menu = await _api.fetchMenu(cafeteriaId);
      _pedidos = await _api.fetchPedidosActivos(cafeteriaId);
      _ultimoEventoWs = 'Datos actualizados desde el servidor';
    } catch (e) {
      _ultimoEventoWs = 'No se pudo conectar con el servidor';
    }
    notifyListeners();
  }

  // --- CONEXIÓN WEBSOCKET (AWS API GATEWAY WEBSOCKET) ---
  void conectarWebSocket(String cafeteriaId) {
    // Cuando el equipo de AWS te dé la URL wss://, descomenta la conexión real:
    // _wsChannel = WebSocketChannel.connect(Uri.parse('wss://tu-id.execute-api.us-east-1.amazonaws.com/prod?cafeteria=$cafeteriaId'));
    _wsConectado = true;
    _ultimoEventoWs = 'Canal WebSocket activo ($cafeteriaId)';
    notifyListeners();
  }

  // --- SINCRONIZACIÓN EN TIEMPO REAL: BOTÓN "AGOTADO" ---
  Future<void> toggleDisponibilidadPlatillo(String id, String cafeteriaId) async {
    final index = _menu.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final platillo = _menu[index];
    platillo.disponible = !platillo.disponible;
    notifyListeners();

    final ok = await _api.savePlatillo(cafeteriaId, platillo);
    if (!ok) {
      platillo.disponible = !platillo.disponible;
      _ultimoEventoWs = 'Error al guardar ${platillo.nombre}';
      notifyListeners();
      return;
    }

    // Payload JSON que se dispara por WebSocket hacia las apps móviles
    final payload = jsonEncode({
      'action': 'SYNC_MENU_STATUS',
      'cafeteriaId': cafeteriaId,
      'platilloId': platillo.id,
      'disponible': platillo.disponible,
      'timestamp': DateTime.now().toIso8601String(),
    });

    _wsChannel?.sink.add(payload);
    _ultimoEventoWs = 'WS Emitido -> ${platillo.nombre}: ${platillo.disponible ? "DISPONIBLE" : "AGOTADO"}';
    notifyListeners();
  }

  // --- AGREGAR O EDITAR PLATILLO ---
  Future<void> guardarPlatillo({
    String? id,
    required String nombre,
    required String categoria,
    required double precio,
    required String cafeteriaId,
  }) async {
    final actual = _menu.where((p) => p.id == id).toList();
    final platillo = Platillo(
      id: id ?? '',
      nombre: nombre,
      categoria: categoria,
      precio: precio,
      disponible: actual.isEmpty ? true : actual.first.disponible,
    );

    final ok = await _api.savePlatillo(cafeteriaId, platillo);
    _ultimoEventoWs = ok ? 'Platillo guardado: $nombre' : 'Error al guardar $nombre';
    await cargarDatos(cafeteriaId);
  }

  // --- TRANSICIÓN DE ESTADOS DEL KANBAN ---
  Future<void> avanzarEstadoPedido(String pedidoId, String cafeteriaId) async {
    final index = _pedidos.indexWhere((p) => p.id == pedidoId);
    if (index == -1) return;

    EstadoPedido? siguiente;
    switch (_pedidos[index].estado) {
      case EstadoPedido.PENDIENTE:
        siguiente = EstadoPedido.EN_PREPARACION;
        break;
      case EstadoPedido.EN_PREPARACION:
        siguiente = EstadoPedido.LISTO;
        break;
      case EstadoPedido.LISTO:
        siguiente = EstadoPedido.ENTREGADO;
        break;
      case EstadoPedido.ENTREGADO:
        break;
    }
    if (siguiente == null) return;

    final ok = await _api.updateEstadoPedido(cafeteriaId, pedidoId, siguiente);
    if (ok) {
      _pedidos[index].estado = siguiente;
      _ultimoEventoWs = 'Pedido $pedidoId pasó a ${siguiente.name}';
    } else {
      _ultimoEventoWs = 'Error al actualizar el pedido $pedidoId';
    }
    notifyListeners();
  }
}
