import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pedido.dart';
import '../models/platillo.dart';
import '../providers/auth_provider.dart';
import '../providers/cafeteria_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // 0 = Kanban Pedidos, 1 = Gestión de Menú

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
          // Barra superior de monitoreo de eventos WebSocket en tiempo real
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
                // Menú lateral Web
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
                // Contenido dinámico
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

// ============================================================================
// VISTA 1: MONITOR DE COLA DE PEDIDOS (KANBAN)
// ============================================================================
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
            // Cabecera de la columna Kanban
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
            // Lista de tarjetas de pedidos
            Expanded(
              child: pedidos.isEmpty
                  ? const Center(child: Text('Sin pedidos', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: pedidos.length,
                      itemBuilder: (context, idx) {
                        final p = pedidos[idx];
                        final minutos = DateTime.now().difference(p.horaPedido).inMinutes;

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
                                      p.id,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF800020)),
                                    ),
                                    Text(
                                      'Hace $minutos min',
                                      style: TextStyle(fontSize: 12, color: minutos > 10 ? Colors.red : Colors.grey.shade700),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('${p.alumnoNombre} (${p.matricula})', style: const TextStyle(fontWeight: FontWeight.w500)),
                                const Divider(),
                                ...p.items.map((item) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                                      child: Text('• $item', style: const TextStyle(fontSize: 13)),
                                    )),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total: \$${p.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                      label: Text(textoBotonAccion, style: const TextStyle(fontSize: 12)),
                                      onPressed: () {
                                        context.read<CafeteriaProvider>().avanzarEstadoPedido(p.id, cafeteriaId);
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
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

// ============================================================================
// VISTA 2: GESTIÓN DEL MENÚ Y BOTÓN DE "AGOTADO" EN TIEMPO REAL
// ============================================================================
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
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: item.disponible ? Colors.green.shade100 : Colors.red.shade100,
                      child: Icon(
                        item.disponible ? Icons.check_circle : Icons.cancel,
                        color: item.disponible ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                    title: Text(
                      item.nombre,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: item.disponible ? null : TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Text('${item.categoria} • \$${item.precio.toStringAsFixed(2)} MXN'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ETIQUETA DE ESTADO
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: item.disponible ? Colors.green.shade50 : Colors.red.shade50,
                            border: Border.all(color: item.disponible ? Colors.green : Colors.red),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.disponible ? 'DISPONIBLE' : 'AGOTADO',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: item.disponible ? Colors.green.shade800 : Colors.red.shade800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // SWITCH TIEMPO REAL (WEBSOCKET)
                        Switch(
                          value: item.disponible,
                          activeColor: Colors.green.shade700,
                          onChanged: (_) {
                            context.read<CafeteriaProvider>().toggleDisponibilidadPlatillo(item.id, cafeteriaId);
                          },
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          tooltip: 'Editar platillo',
                          onPressed: () => _mostrarModalPlatillo(context, platillo: item),
                        ),
                      ],
                    ),
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