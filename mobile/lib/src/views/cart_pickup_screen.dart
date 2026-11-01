import 'package:flutter/material.dart';

class CartPickupScreen extends StatelessWidget {
  const CartPickupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Carrito & Pick-Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    title: Text('Chilaquiles verdes con pollo'),
                    subtitle: Text('Cantidad: 1'),
                    trailing: Text('\$45.00', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Café Americano (12oz)'),
                    subtitle: Text('Cantidad: 1'),
                    trailing: Text('\$20.00', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total a Pagar:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('\$65.00', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/ticket');
              },
              child: const Text('Generar Pedido y Ticket QR', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}