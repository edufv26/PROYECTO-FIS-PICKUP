import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/platillo.dart';
import '../models/pedido.dart';

class AwsApiService {
  static const String _baseUrl = 'http://localhost:3000';
  static String? token;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<Map<String, dynamic>> login(String correo, String password) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({'correo': correo, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(data['error'] ?? 'Error al iniciar sesión');
    }
    return data;
  }

  Future<List<Platillo>> fetchMenu(String cafeteriaId) async {
    final uri = Uri.parse('$_baseUrl/cafeterias/$cafeteriaId/menu');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Platillo.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar el menú: ${response.statusCode}');
    }
  }

  Future<bool> savePlatillo(String cafeteriaId, Platillo platillo) async {
    final uri = Uri.parse('$_baseUrl/cafeterias/$cafeteriaId/menu');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode(platillo.toJson()),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<List<Pedido>> fetchPedidosActivos(String cafeteriaId) async {
    final uri = Uri.parse('$_baseUrl/cafeterias/$cafeteriaId/pedidos');
    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Pedido.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar pedidos: ${response.statusCode}');
    }
  }

  Future<bool> updateEstadoPedido(String cafeteriaId, String pedidoId, EstadoPedido nuevoEstado) async {
    final uri = Uri.parse('$_baseUrl/cafeterias/$cafeteriaId/pedidos/$pedidoId/estado');
    final response = await http.patch(
      uri,
      headers: _headers,
      body: jsonEncode({'estado': nuevoEstado.name}),
    );
    return response.statusCode == 200;
  }
}
