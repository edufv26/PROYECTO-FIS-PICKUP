import 'package:flutter/material.dart';
import '../models/platillo.dart';

class PlatilloTile extends StatelessWidget {
  final Platillo platillo;
  final VoidCallback onToggleDisponibilidad;
  final VoidCallback onEditar;

  const PlatilloTile({
    super.key,
    required this.platillo,
    required this.onToggleDisponibilidad,
    required this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: platillo.disponible ? Colors.green.shade100 : Colors.red.shade100,
        child: Icon(
          platillo.disponible ? Icons.check_circle : Icons.cancel,
          color: platillo.disponible ? Colors.green.shade800 : Colors.red.shade800,
        ),
      ),
      title: Text(
        platillo.nombre,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          decoration: platillo.disponible ? null : TextDecoration.lineThrough,
        ),
      ),
      subtitle: Text('${platillo.categoria} • \$${platillo.precio.toStringAsFixed(2)} MXN'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: platillo.disponible ? Colors.green.shade50 : Colors.red.shade50,
              border: Border.all(color: platillo.disponible ? Colors.green : Colors.red),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              platillo.disponible ? 'DISPONIBLE' : 'AGOTADO',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: platillo.disponible ? Colors.green.shade800 : Colors.red.shade800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: platillo.disponible,
            activeColor: Colors.green.shade700,
            onChanged: (_) => onToggleDisponibilidad(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar platillo',
            onPressed: onEditar,
          ),
        ],
      ),
    );
  }
}