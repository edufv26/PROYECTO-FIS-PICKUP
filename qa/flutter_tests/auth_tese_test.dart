import 'package:flutter_test/flutter_test.dart';

/// Valida que el correo pertenezca al dominio institucional del TESE.
bool esCorreoInstitucionalTese(String correo) {
  final limpio = correo.trim().toLowerCase();
  return limpio.endsWith('@tese.edu.mx') && limpio.length > '@tese.edu.mx'.length;
}

/// Determina el rol inicial segun el prefijo o tipo de cuenta institucional.
String asignarRolPorCorreo(String correo) {
  final limpio = correo.trim().toLowerCase();
  if (!esCorreoInstitucionalTese(limpio)) {
    throw ArgumentError('Correo no autorizado: debe ser @tese.edu.mx');
  }
  if (limpio.startsWith('cocina.') || limpio.startsWith('cafeteria.')) {
    return 'cafeteria';
  }
  if (limpio.startsWith('admin.')) {
    return 'admin';
  }
  return 'estudiante';
}

void main() {
  group('RF01 - Pruebas de autenticacion institucional TESE', () {
    test('Acepta correo valido de estudiante @tese.edu.mx', () {
      expect(esCorreoInstitucionalTese('202320045@tese.edu.mx'), isTrue);
      expect(assignarRolSeguro('202320045@tese.edu.mx'), equals('estudiante'));
    });

    test('Rechaza correos externos como Gmail o Hotmail', () {
      expect(esCorreoInstitucionalTese('alumno@gmail.com'), isFalse);
      expect(esCorreoInstitucionalTese('profesor@hotmail.com'), isFalse);
      expect(
        () => asignarRolPorCorreo('alumno@gmail.com'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Asigna rol cafeteria a cuentas operativas del punto de venta', () {
      expect(assignarRolSeguro('cocina.central@tese.edu.mx'), equals('cafeteria'));
    });
  });
}

String assignarRolSeguro(String correo) => asignarRolPorCorreo(correo);
