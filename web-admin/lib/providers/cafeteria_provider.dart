import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/platillo.dart';
import '../models/pedido.dart';

class CafeteriaProvider extends ChangeNotifier {
  WebSocketChannel? _wsChannel;
  bool _wsConectado = false;
  String _ultimoEventoWs = 'Sin eventos recientes';

  bool get wsConectado => _wsConectado;
  String get ultimoEventoWs => _ultimoEventoWs;

  // Menú inicial de prueba para las cafeterías del TESE
  final List<Platillo> _menu = [
    Platillo(id: 'P1', nombre: 'Chilaquiles Verdes con Pollo', categoria: 'Desayunos', precio: 55.0, disponible: true),
    Platillo(id: 'P2', nombre: 'Torta de Milanesa Especial', categoria: 'Tortas', precio: 48.0, disponible: true),
    Platillo(id: 'P3', nombre: 'Orden de 3 Quesadillas', categoria: 'Antojitos', precio: 42.0, disponible: true),
    Platillo(id: 'P4', nombre: 'Enchiladas Suizas', categoria: 'Comida Corrida', precio: 60.0, disponible: false),
    Platillo(id: 'P5', nombre: 'Agua Fresca de Horchata (1L)', categoria: 'Bebidas', precio: 25.0, disponible: true),
  ];

  // Cola de pedidos inicial (Kanban)
  final List<Pedido> _pedidos = [
    Pedido(
      id: 'ORD-101',
      alumnoNombre: 'Carlos Hernández',
      matricula: '202104012',
      items: ['1x Chilaquiles Verdes con Pollo', '1x Agua Fresca de Horchata (1L)'],
      total: 80.0,
      horaPedido: DateTime.now().subtract(const Duration(minutes: 12)),
      estado: EstadoPedido.PENDIENTE,
    ),
    Pedido(
      id: 'ORD-102',
      alumnoNombre: 'Ana Sofía Gómez',
      matricula: '202209104',
      items: ['2x Orden de 3 Quesadillas'],
      total: 84.0,
      horaPedido: DateTime.now().subtract(const Duration(minutes: 8)),
      estado: EstadoPedido.EN_PREPARACION,
    ),
    Pedido(
      id: 'ORD-103',
      alumnoNombre: 'Luis Fernando Ruiz',
      matricula: '202011088',
      items: ['1x Torta de Milanesa Especial'],
      total: 48.0,
      horaPedido: DateTime.now().subtract(const Duration(minutes: 3)),
      estado: EstadoPedido.LISTO,
    ),
  ];

  List<Platillo> get menu => _menu;

  List<Pedido> obtenerPedidosPorEstado(EstadoPedido estado) {
    final lista = _pedidos.where((p) => p.estado == estado).toList();
    // Orden cronológico para evitar saturación en horas pico
    lista.sort((a, b) => a.horaPedido.compareTo(b.horaPedido));
    return lista;
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
  void toggleDisponibilidadPlatillo(String id, String cafeteriaId) {
    final index = _menu.indexWhere((p) => p.id == id);
    if (index != -1) {
      _menu[index].disponible = !_menu[index].disponible;
      final platillo = _menu[index];

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
  }

  // --- AGREGAR O EDITAR PLATILLO ---
  void guardarPlatillo({String? id, required String nombre, required String categoria, required double precio}) {
    if (id == null) {
      final nuevoId = 'P${_menu.length + 1}';
      _menu.add(Platillo(id: nuevoId, nombre: nombre, categoria: categoria, precio: precio));
    } else {
      final index = _menu.indexWhere((p) => p.id == id);
      if (index != -1) {
        _menu[index].nombre = nombre;
        _menu[index].categoria = categoria;
        _menu[index].precio = precio;
      }
    }
    notifyListeners();
  }

  // --- TRANSICIÓN DE ESTADOS DEL KANBAN ---
  void avanzarEstadoPedido(String pedidoId, String cafeteriaId) {
    final index = _pedidos.indexWhere((p) => p.id == pedidoId);
    if (index != -1) {
      final actual = _pedidos[index].estado;
      EstadoPedido? siguiente;

      switch (actual) {
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

      if (siguiente != null) {
        _pedidos[index].estado = siguiente;
        _ultimoEventoWs = 'WS Emitido -> Pedido $pedidoId pasó a ${siguiente.name}';
        notifyListeners();
      }
    }
  }

  // Simulador para que pruebes cómo llegan órdenes nuevas en tiempo real
  void simularNuevoPedido() {
    final randomNum = 104 + _pedidos.length;
    _pedidos.add(
      Pedido(
        id: 'ORD-$randomNum',
        alumnoNombre: 'Estudiante TESE #$randomNum',
        matricula: '202310$randomNum',
        items: ['1x Torta de Milanesa Especial', '1x Agua Fresca de Horchata (1L)'],
        total: 73.0,
        horaPedido: DateTime.now(),
        estado: EstadoPedido.PENDIENTE,
      ),
    );
    _ultimoEventoWs = 'WS Recibido <- Nueva orden entrante ORD-$randomNum';
    notifyListeners();
  }
}