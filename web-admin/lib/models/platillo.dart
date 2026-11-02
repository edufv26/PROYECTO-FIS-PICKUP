class Platillo {
  final String id;
  String nombre;
  String categoria;
  double precio;
  bool disponible; // false = AGOTADO

  Platillo({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    this.disponible = true,
  });

  // Listo para cuando recibas el JSON desde AWS API Gateway
  factory Platillo.fromJson(Map<String, dynamic> json) {
    return Platillo(
      id: json['id'],
      nombre: json['nombre'],
      categoria: json['categoria'],
      precio: (json['precio'] as num).toDouble(),
      disponible: json['disponible'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'categoria': categoria,
        'precio': precio,
        'disponible': disponible,
      };
}