import 'package:flutter/material.dart';
import '../models/promocion.dart';
import '../utils/bank_styles.dart'; 

class PromoCard extends StatelessWidget {
  final Promocion promo;
  final VoidCallback? onTap;

  const PromoCard({super.key, required this.promo, this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = bankStyles[promo.institucionId]; // si no lo tenés, reemplazá por null
    final color = style?.color ?? Theme.of(context).colorScheme.primary;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color.withOpacity(0.15),
                child: style?.logoAsset != null
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(style!.logoAsset!),
                      )
                    : Icon(Icons.percent, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(promo.titulo,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      promo.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: -8,
                      children: [
                        _Tag(text: promo.banco, color: color),
                        _Tag(text: 'Vigencia: ${promo.vigencia}'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color? color;
  const _Tag({required this.text, this.color});
  @override
  Widget build(BuildContext context) {
    final bg = (color ?? Colors.grey).withOpacity(0.12);
    final fg = color ?? Colors.grey[800];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: TextStyle(color: fg, fontSize: 12)),
    );
  }
}
