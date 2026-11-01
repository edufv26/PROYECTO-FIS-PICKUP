import 'package:flutter/material.dart';
import 'src/views/login_screen.dart';
import 'src/views/menu_catalog_screen.dart';
import 'src/views/cart_pickup_screen.dart';
import 'src/views/ticket_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FIS Pickup Web',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Definimos la ruta inicial que será tu pantalla de Login
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/catalog': (context) => const MenuCatalogScreen(),
        '/cart': (context) => const CartPickupScreen(),
        '/ticket': (context) => const TicketScreen(),
        // Si quieres conservar tu panel web original como una ruta extra, lo puedes agregar aquí:
        '/admin-web': (context) => const PickupHomePage(),
      },
    );
  }
}

// Conservamos tu panel original intacto por si el equipo lo sigue usando en la web
class PickupHomePage extends StatelessWidget {
  const PickupHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROYECTO FIS-PICKUP (Web)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Panel de Control en Tiempo Real',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí activaremos la conexión con AWS
                print('Conectando a WebSockets de AWS...');
              },
              child: const Text('Conectar con AWS WebSocket'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Botón rápido para ir al flujo de estudiante
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Ir al Login de Estudiante'),
            ),
          ],
        ),
      ),
    );
  }
}