import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/promocion.dart';
import '../utils/bank_styles.dart'; // si lo tenés separado

class PromotionDetailPage extends StatelessWidget {
  final Promocion promo;

  const PromotionDetailPage({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    final style = bankStyles[promo.institucionId];
    final color = style?.color ?? Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(promo.banco),
        backgroundColor: color,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner o logo
            if (style?.logoAsset != null)
              Center(
                child: Image.asset(
                  style!.logoAsset!,
                  height: 80,
                ),
              )
            else
              Center(
                child: Icon(Icons.percent, size: 80, color: color),
              ),
            const SizedBox(height: 16),

            // Título
            Text(
              promo.titulo,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Descripción
            Text(
              promo.descripcion,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Vigencia
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 6),
                Text("Válido hasta: ${promo.vigencia}"),
              ],
            ),
            const SizedBox(height: 24),

            // 👇 Acá podés insertar el bloque de bases y condiciones
            if (promo.termsSummary != null) ...[
              const SizedBox(height: 12),
              Text(promo.termsSummary!, style: const TextStyle(color: Colors.grey)),
            ],

            if (promo.termsMarkdown != null) ...[
              const SizedBox(height: 12),
              ExpansionTile(
                title: const Text("Ver bases y condiciones"),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MarkdownBody(data: promo.termsMarkdown!), // flutter_markdown
                  ),
                ],
              ),
            ],

            if (promo.termsUrl != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: const Text("Bases completas"),
                onPressed: () => launchUrl(Uri.parse(promo.termsUrl!)), // url_launcher
              ),
            ],

            const SizedBox(height: 24), 

            // Botón de compartir
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.share),
                label: const Text("Compartir promoción"),
                onPressed: () {
                  Share.share(
                    "${promo.titulo} - ${promo.descripcion}\nVigente hasta ${promo.vigencia}",
                    subject: "Promo de ${promo.banco}",
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Función compartir demo")),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
