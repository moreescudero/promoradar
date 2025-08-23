import 'package:flutter/foundation.dart';
import '../models/promocion.dart';
import '../services/promocion_service.dart';

class PromocionesProvider extends ChangeNotifier {
  List<Promocion> _todas = [];
  List<Promocion> _filtradas = [];
  String _query = '';
  bool _cargando = true;
  Object? _error;

  final Set<String> _categoriasSel = {}; 

  List<Promocion> get todas => _todas;
  List<Promocion> get filtradas => _filtradas;
  String get query => _query;
  bool get cargando => _cargando;
  Object? get error => _error;
  Set<String> get categoriasSeleccionadas => _categoriasSel;

  // --- categorías ---
  void toggleCategoria(String catId) {
    final id = catId.toLowerCase();
    if (_categoriasSel.contains(id)) {
      _categoriasSel.remove(id);
    } else {
      _categoriasSel.add(id);
    }
    notifyListeners();
  }
  void limpiarCategorias() {
    _categoriasSel.clear();
    notifyListeners();
  }
  bool categoriaActiva(String id) => _categoriasSel.contains(id.toLowerCase());


  List<Promocion> filtrarPorInstituciones(Set<String> ids) {
    if (ids.isEmpty) return []; // si no eligió nada, no mostramos nada
    return _todas.where((p) => ids.contains(p.institucionId)).toList();
  }

  List<Promocion> filtrar(Set<String> ids, String q) {
    final base = filtrarPorInstituciones(ids);
    if (q.trim().isEmpty) return base;
    final s = q.toLowerCase();
    return base.where((p) =>
      p.banco.toLowerCase().contains(s) ||
      p.titulo.toLowerCase().contains(s) ||
      p.descripcion.toLowerCase().contains(s)
    ).toList();
  }
  // --- filtro final combinando instituciones + categorías + query ---
  List<Promocion> filtrarFinal(Set<String> instIds) {
    List<Promocion> base = filtrarPorInstituciones(instIds);

    // categorías
    if (_categoriasSel.isNotEmpty) {
      base = base.where((p) =>
        p.categorias.any((c) => _categoriasSel.contains(c.toLowerCase()))
      ).toList();
    }

    // texto
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      base = base.where((p) =>
        p.banco.toLowerCase().contains(q) ||
        p.titulo.toLowerCase().contains(q) ||
        p.descripcion.toLowerCase().contains(q)
      ).toList();
    }

    return base;
  }

  Future<void> init() async {
    try {
      _cargando = true;
      notifyListeners();
      _todas = await PromocionService.cargarPromociones();
      _aplicarFiltro(); // inicial
    } catch (e) {
      _error = e;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void setQuery(String q) {
    _query = q;
    _aplicarFiltro();
    notifyListeners();
  }

  void _aplicarFiltro() {
    if (_query.trim().isEmpty) {
      _filtradas = List.from(_todas);
      return;
    }
    final q = _query.toLowerCase();
    _filtradas = _todas.where((p) {
      return p.banco.toLowerCase().contains(q) ||
             p.titulo.toLowerCase().contains(q) ||
             p.descripcion.toLowerCase().contains(q);
    }).toList();
  }
}
