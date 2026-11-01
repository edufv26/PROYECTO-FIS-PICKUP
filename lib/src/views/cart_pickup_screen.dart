import 'package:flutter/material.dart';

class CartPickupScreen extends StatelessWidget {
  const CartPickupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito & Pick-Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Expanded(
              child: ListTile(
                title: Text('Chilaquiles sencillos'),
                subtitle: Text('Hora estimada de recogida: 11:30 AM'),
                trailing: Text('\$45.00'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pedido Confirmado'),
                    content: const Text('Presenta tu folio en caja para pagar y recoger.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Confirmar Pedido Pick-Up'),
            ),
          ],
        ),
      ),
    );
  }
}