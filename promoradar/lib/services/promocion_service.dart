import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/promocion.dart';

class PromocionService {
  static Future<List<Promocion>> cargarPromociones() async {
    final String response =
        await rootBundle.loadString('/promociones.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => Promocion.fromJson(e)).toList();
  }
}
  