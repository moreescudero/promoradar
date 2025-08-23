class Institucion {
  final String id;   // "santander", "galicia", "mercadopago"
  final String nombre;

  const Institucion({required this.id, required this.nombre});

  factory Institucion.fromJson(Map<String, dynamic> j) =>
      Institucion(id: j['id'], nombre: j['nombre']);
}
