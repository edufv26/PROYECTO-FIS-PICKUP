import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget simplificado que representa el control de 1 tap en el KDS de cocina (HU-F02).
class KdsPlatilloTile extends StatefulWidget {
  final String nombrePlatillo;
  final bool disponibleInicial;
  final VoidCallback? onAgotado;

  const KdsPlatilloTile({
    super.key,
    required this.nombrePlatillo,
    this.disponibleInicial = true,
    this.onAgotado,
  });

  @override
  State<KdsPlatilloTile> createState() => _KdsPlatilloTileState();
}

class _KdsPlatilloTileState extends State<KdsPlatilloTile> {
  late bool _disponible;

  @override
  void initState() {
    super.initState();
    _disponible = widget.disponibleInicial;
  }

  void _marcarAgotado() {
    setState(() {
      _disponible = false;
    });
    widget.onAgotado?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.nombrePlatillo),
      subtitle: Text(_disponible ? 'Disponible' : 'Agotado'),
      trailing: ElevatedButton(
        onPressed: _disponible ? _marcarAgotado : null,
        child: const Text('Agotar'),
      ),
    );
  }
}

void main() {
  group('HU-F02 / RF06 - Pruebas de widget para el Tablero KDS', () {
    testWidgets('Cambia estado a Agotado en 1 tap y dispara callback', (tester) async {
      var callbackDisparado = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KdsPlatilloTile(
              nombrePlatillo: 'Torta de Milanesa',
              onAgotado: () {
                callbackDisparado = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Disponible'), findsOneWidget);

      await tester.tap(find.text('Agotar'));
      await tester.pump();

      expect(find.text('Agotado'), findsOneWidget);
      expect(callbackDisparado, isTrue);
    });
  });
}
