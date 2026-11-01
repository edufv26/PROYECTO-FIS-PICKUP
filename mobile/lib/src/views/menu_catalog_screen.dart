import 'package:flutter/material.dart';

class MenuCatalogScreen extends StatelessWidget {
  const MenuCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú de la Cafetería'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.fastfood, color: Colors.orange, size: 40),
              title: const Text('Chilaquiles verdes con pollo', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('\$45.00 - Disponible'),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Agregado al carrito!')),
                  );
                },
                child: const Text('Agregar'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_drink, color: Colors.brown, size: 40),
              title: const Text('Café Americano (12oz)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('\$20.00 - Caliente'),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('¡Agregado al carrito!')),
                  );
                },
                child: const Text('Agregar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}