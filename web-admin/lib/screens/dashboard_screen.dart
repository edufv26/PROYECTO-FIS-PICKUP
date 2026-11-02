import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pedido.dart';
import '../models/platillo.dart';
import '../providers/auth_provider.dart';
import '../providers/cafeteria_provider.dart';
import '../widgets/pedido_card.dart';
import '../widgets/platillo_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cafId = context.read<AuthProvider>().cafeteriaId ?? 'CAF_GRANDE';
      context.read<CafeteriaProvider>().conectarWebSocket(cafId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cafProvider = context.watch<CafeteriaProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF800020),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.storefront),
            const SizedBox(width: 10),
            Text('TESE-Eats | ${auth.cafeteriaNombre}'),
            const SizedBox(width: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.bolt, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text('WebSocket Activo', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (_selectedIndex == 0)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: Colors.amber.shade800),
                icon: const Icon(Icons.notifications_active, size: 18),
                label: const Text('Simular Pedido Entrante'),
                onPressed: () => cafProvider.simularNuevoPedido(),
              ),
            ),
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.logout),
            label: const Text('Salir'),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey.shade900,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.sync_alt, color: Colors.greenAccent, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Monitor AWS Tiempo Real: ${cafProvider.ultimoEventoWs}',
                  style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
                  extended: true,
                  backgroundColor: Colors.white,
                  selectedIconTheme: const IconThemeData(color: Color(0xFF800020)),
                  selectedLabelTextStyle: const TextStyle(color: Color(0xFF800020), fontWeight: FontWeight.bold),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.view_kanban_outlined),
                      selectedIcon: Icon(Icons.view_kanban),
                      label: Text('Cola de Pedidos (Kanban)'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.restaurant_menu_outlined),
                      selectedIcon: Icon(Icons.restaurant_menu),
                      label: Text('Gestión del Menú'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: _selectedIndex == 0
                      ? _KanbanView(cafeteriaId: auth.cafeteriaId ?? 'CAF_GRANDE')
                      : _MenuManagementView(cafeteriaId: auth.cafeteriaId ?? 'CAF_GRANDE'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KanbanView extends StatelessWidget {
  final String cafeteriaId;
  const _KanbanView({required this.cafeteriaId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildColumn(context, 'PENDIENTE', EstadoPedido.PENDIENTE, Colors.orange.shade800, 'Iniciar Preparación'),
          const SizedBox(width: 12),
          _buildColumn(context, 'EN PREPARACIÓN', EstadoPedido.EN_PREPARACION, Colors.blue.shade700, 'Marcar como LISTO'),
          const SizedBox(width: 12),
          _buildColumn(context, 'LISTO PARA RECOGER', EstadoPedido.LISTO, Colors.green.shade700, 'Marcar ENTREGADO'),
          const SizedBox(width: 12),
          _buildColumn(context, 'ENTREGADO', EstadoPedido.ENTREGADO, Colors.grey.shade700, null),
        ],
      ),
    );
  }

  Widget _buildColumn(
    BuildContext context,
    String titulo,
    EstadoPedido estado,
    Color colorHeader,
    String? textoBotonAccion,
  ) {
    final pedidos = context.watch<CafeteriaProvider>().obtenerPedidosPorEstado(estado);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: colorHeader,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Text(
                      '${pedidos.length}',
                      style: TextStyle(color: colorHeader, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: pedidos.isEmpty
                  ? const Center(child: Text('Sin pedidos', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: pedidos.length,
                      itemBuilder: (context, idx) {
                        final p = pedidos[idx];
                        return PedidoCard(
                          pedido: p,
                          colorHeader: colorHeader,
                          textoBotonAccion: textoBotonAccion,
                          onAvanzarEstado: () {
                            context.read<CafeteriaProvider>().avanzarEstadoPedido(p.id, cafeteriaId);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuManagementView extends StatelessWidget {
  final String cafeteriaId;
  const _MenuManagementView({required this.cafeteriaId});

  void _mostrarModalPlatillo(BuildContext context, {Platillo? platillo}) {
    final nombreCtrl = TextEditingController(text: platillo?.nombre ?? '');
    final categoriaCtrl = TextEditingController(text: platillo?.categoria ?? 'Comida Corrida');
    final precioCtrl = TextEditingController(text: platillo?.precio.toString() ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(platillo == null ? 'Agregar Nuevo Platillo' : 'Editar Platillo'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre del Platillo', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoriaCtrl,
                decoration: const InputDecoration(labelText: 'Categoría (ej. Tortas, Bebidas)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: precioCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio (\$ MXN)', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF800020), foregroundColor: Colors.white),
            onPressed: () {
              final nombre = nombreCtrl.text.trim();
              final cat = categoriaCtrl.text.trim();
              final precio = double.tryParse(precioCtrl.text.trim()) ?? 0.0;
              if (nombre.isNotEmpty && precio > 0) {
                context.read<CafeteriaProvider>().guardarPlatillo(
                      id: platillo?.id,
                      nombre: nombre,
                      categoria: cat,
                      precio: precio,
                    );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menu = context.watch<CafeteriaProvider>().menu;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Inventario y Menú del Día', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Desactiva el interruptor para marcar un platillo como AGOTADO instantáneamente en la app móvil.'),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF800020),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Nuevo Platillo'),
                onPressed: () => _mostrarModalPlatillo(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              elevation: 2,
              child: ListView.separated(
                itemCount: menu.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, idx) {
                  final item = menu[idx];
                  return PlatilloTile(
                    platillo: item,
                    onToggleDisponibilidad: () {
                      context.read<CafeteriaProvider>().toggleDisponibilidadPlatillo(item.id, cafeteriaId);
                    },
                    onEditar: () => _mostrarModalPlatillo(context, platillo: item),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}