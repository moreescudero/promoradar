import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/institucion.dart';

class InstitucionService {
  static Future<List<Institucion>> cargarInstituciones() async {
    final String response =
        await rootBundle.loadString('/instituciones.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => Institucion.fromJson(e)).toList();
  }
}
  