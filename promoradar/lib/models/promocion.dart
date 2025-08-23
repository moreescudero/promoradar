class Promocion {
  final String banco;
  final String institucionId;
  final String titulo;
  final String descripcion;
  final String vigencia;
  final List<String> categorias;

  Promocion({
    required this.banco,
    required this.institucionId,
    required this.titulo,
    required this.descripcion,
    required this.vigencia,
    required this.categorias, 
  });

  factory Promocion.fromJson(Map<String, dynamic> json) {
    return Promocion(
      banco: json['banco'],
      institucionId: json['institucionId'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      vigencia: json['vigencia'],
      categorias: (json['categorias'] as List).map((e) => e.toString().toLowerCase()).toList(),
    );
  }
}