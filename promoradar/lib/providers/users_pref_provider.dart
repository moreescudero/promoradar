import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefsProvider extends ChangeNotifier {
  static const _kKeySel = 'instituciones_seleccionadas';
  final Set<String> _seleccionadas = {}; // ids: {"galicia","bbva",...}
  bool _cargando = true;

  bool get cargando => _cargando;
  Set<String> get seleccionadas => _seleccionadas;

  Future<void> init() async {
    _cargando = true; notifyListeners();
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_kKeySel) ?? [];
    _seleccionadas..clear()..addAll(list);
    _cargando = false; notifyListeners();
  }

  Future<void> toggle(String institucionId) async {
    if (_seleccionadas.contains(institucionId)) {
      _seleccionadas.remove(institucionId);
    } else {
      _seleccionadas.add(institucionId);
    }
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(_kKeySel, _seleccionadas.toList());
    notifyListeners();
  }

  bool isSelected(String id) => _seleccionadas.contains(id);
}
