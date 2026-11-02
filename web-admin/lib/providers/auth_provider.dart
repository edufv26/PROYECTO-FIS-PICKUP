import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _cafeteriaId;
  String? _cafeteriaNombre;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get cafeteriaId => _cafeteriaId;
  String? get cafeteriaNombre => _cafeteriaNombre;

  Future<bool> login(String usuario, String password, String cafeteriaSeleccionada) async {
    _isLoading = true;
    notifyListeners();

    // Simulación de retraso de red (AWS)
    await Future.delayed(const Duration(seconds: 1));

    // Credenciales de prueba para desarrollo local
    if (usuario.isNotEmpty && password == 'tese123') {
      _isAuthenticated = true;
      _cafeteriaId = cafeteriaSeleccionada;
      
      switch (cafeteriaSeleccionada) {
        case 'CAF_GRANDE':
          _cafeteriaNombre = 'Cafetería Principal (Grande)';
          break;
        case 'CAF_CHICA_1':
          _cafeteriaNombre = 'Cafetería Pequeña 1';
          break;
        case 'CAF_CHICA_2':
          _cafeteriaNombre = 'Cafetería Pequeña 2';
          break;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _cafeteriaId = null;
    _cafeteriaNombre = null;
    notifyListeners();
  }
}