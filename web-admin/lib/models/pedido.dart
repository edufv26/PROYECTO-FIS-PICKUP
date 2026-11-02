enum EstadoPedido { PENDIENTE, EN_PREPARACION, LISTO, ENTREGADO }

class Pedido {
  final String id;
  final String alumnoNombre;
  final String matricula;
  final List<String> items;
  final double total;
  final DateTime horaPedido;
  EstadoPedido estado;

  Pedido({
    required this.id,
    required this.alumnoNombre,
    required this.matricula,
    required this.items,
    required this.total,
    required this.horaPedido,
    this.estado = EstadoPedido.PENDIENTE,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      alumnoNombre: json['alumnoNombre'],
      matricula: json['matricula'],
      items: List<String>.from(json['items'] ?? []),
      total: (json['total'] as num).toDouble(),
      horaPedido: DateTime.parse(json['horaPedido']),
      estado: EstadoPedido.values.firstWhere(
        (e) => e.name == json['estado'],
        orElse: () => EstadoPedido.PENDIENTE,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'alumnoNombre': alumnoNombre,
        'matricula': matricula,
        'items': items,
        'total': total,
        'horaPedido': horaPedido.toIso8601String(),
        'estado': estado.name,
      };
}