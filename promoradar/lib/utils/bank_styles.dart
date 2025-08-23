import 'dart:ui';

class _BankStyle {
  final String name;
  final Color color;
  final String? logoAsset;
  const _BankStyle({required this.name, required this.color, this.logoAsset});
}

// Mapear por institucionId (el mismo que viene en tu JSON)
const bankStyles = <String, _BankStyle>{
  'galicia': _BankStyle(
    name: 'Banco Galicia',
    color: Color(0xFFFF6600),
    logoAsset: '../assets/logos/Galicia.jpg',
  ),
  'santander': _BankStyle(
    name: 'Santander Río',
    color: Color(0xFFE60012),
    logoAsset: '../assets/logos/Santander.png',
  ),
  'bbva': _BankStyle(
    name: 'BBVA',
    color: Color(0xFF0D47A1),
    logoAsset: '../assets/logos/BBVA.png',
  ),
  'mercadopago': _BankStyle(
    name: 'Mercado Pago',
    color: Color(0xFF00AEEF),
    logoAsset: '../assets/logos/MercadoPago.png',
  ),
};
