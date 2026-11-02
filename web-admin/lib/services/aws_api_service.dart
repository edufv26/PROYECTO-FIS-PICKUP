import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/platillo.dart';
import '../models/pedido.dart';

class AwsApiService {
  // URL base de AWS API Gateway (Reemplazar cuando el equipo de Backend despliegue)
  static const String _baseUrl = 'https://tu-api-id.execute-api.us-east-1.amazonaws.com/prod';

  // 1. Obtener el menú del día de una cafetería específica
  Future<List<Platillo>> fetchMenu(String cafeteriaId) async {
    final uri = Uri.parse('$_baseUrl/cafeterias/$cafeteriaId/menu');
    final response = await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Platillo.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar el menú desde AWS: ${response.statusCode}');
    }
  }

  // 2. Crear o actualizar un platillo en AWS
  Future<bool> savePlatillo(String cafeteriaId, Platillo platillo) async {
    final uri = Uri.parse('$_baseUrl/cafeterias/$cafeteriaId/menu');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(platillo.toJson()),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // 3. Obtener la cola de pedidos activos para el Kanban
  Future<List<Pedido>> fetchPedidosActivos(String cafeteriaId) async {
    final uri = Uri.parse('$_baseUrl/cafeterias/$cafeteriaId/pedidos');
    final response = await http.get(uri, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Pedido.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar pedidos desde AWS: ${response.statusCode}');
    }
  }

  // 4. Actualizar el estado de un pedido (PENDIENTE -> EN_PREPARACION -> LISTO -> ENTREGADO)
  Future<bool> updateEstadoPedido(String cafeteriaId, String pedidoId, EstadoPedido nuevoEstado) async {
    final uri = Uri.parse('$_baseUrl/cafeterias/$cafeteriaId/pedidos/$pedidoId/estado');
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'estado': nuevoEstado.name}),
    );
    return response.statusCode == 200;
  }
}