import 'package:flutter/material.dart';

class MenuCatalogScreen extends StatelessWidget {
  const MenuCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Cafetería'),
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
          ListTile(
            leading: const Icon(Icons.fastfood),
            title: const Text('Chilaquiles sencillos'),
            subtitle: const Text('\$45.00'),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Agregado al carrito')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}