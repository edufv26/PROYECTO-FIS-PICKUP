import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIS Pickup Web',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PickupHomePage(),
    );
  }
}

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
          ],
        ),
      ),
    );
  }
}