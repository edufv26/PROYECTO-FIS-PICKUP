import 'package:flutter/material.dart';
import '../services/aws_api_service.dart';

class AuthProvider extends ChangeNotifier {
  final AwsApiService _api = AwsApiService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _cafeteriaId;
  String? _cafeteriaNombre;
  String? _error;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get cafeteriaId => _cafeteriaId;
  String? get cafeteriaNombre => _cafeteriaNombre;
  String? get error => _error;

  Future<bool> login(String correo, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.login(correo, password);

      if (data['rol'] != 'cafeteria') {
        _error = 'Esta cuenta no es de personal de cafetería';
      } else {
        AwsApiService.token = data['token'];
        _cafeteriaId = data['id_cafeteria'];
        _cafeteriaNombre = data['cafeteria_nombre'];
        _isAuthenticated = true;
      }
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
    return _isAuthenticated;
  }

  void logout() {
    AwsApiService.token = null;
    _isAuthenticated = false;
    _cafeteriaId = null;
    _cafeteriaNombre = null;
    notifyListeners();
  }
}
