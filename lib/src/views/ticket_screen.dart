import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Digital de Recogida')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '¡Pedido en Preparación!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            const Text('Presenta este código QR en la ventanilla de la cafetería.'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: const Column(
                children: [
                  Icon(Icons.qr_code_2, size: 180, color: Colors.black87),
                  SizedBox(height: 8),
                  Text('Folio: #TESE-8492', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Resumen del Ticket:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Divider(),
                    Text('• 1x Chilaquiles verdes con pollo'),
                    Text('• 1x Café Americano (12oz)'),
                    SizedBox(height: 8),
                    Text('Total Pagado: \$65.00', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Estimación de entrega: 10 - 15 mins'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/catalog', (route) => false);
              },
              child: const Text('Regresar al Menú Principal'),
            ),
          ],
        ),
      ),
    );
  }
}