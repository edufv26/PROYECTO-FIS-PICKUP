import 'package:flutter/material.dart';
import '../models/pedido.dart';

class PedidoCard extends StatelessWidget {
  final Pedido pedido;
  final Color colorHeader;
  final String? textoBotonAccion;
  final VoidCallback onAvanzarEstado;

  const PedidoCard({
    super.key,
    required this.pedido,
    required this.colorHeader,
    this.textoBotonAccion,
    required this.onAvanzarEstado,
  });

  @override
  Widget build(BuildContext context) {
    final minutos = DateTime.now().difference(pedido.horaPedido).inMinutes;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pedido.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF800020),
                  ),
                ),
                Text(
                  'Hace $minutos min',
                  style: TextStyle(
                    fontSize: 12,
                    color: minutos >= 10 ? Colors.red : Colors.grey.shade700,
                    fontWeight: minutos >= 10 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${pedido.alumnoNombre} (${pedido.matricula})',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const Divider(),
            ...pedido.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text('• $item', style: const TextStyle(fontSize: 13)),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${pedido.total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (textoBotonAccion != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorHeader,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: Text(textoBotonAccion!, style: const TextStyle(fontSize: 12)),
                  onPressed: onAvanzarEstado,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}