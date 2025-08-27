import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/promociones_provider.dart';
import '../providers/users_pref_provider.dart';
import '../widgets/promo_card.dart';
import 'promotion_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PromocionesProvider>();
    final prefs = context.watch<UserPrefsProvider>();

    final cargando = prov.cargando || prefs.cargando;
    if (cargando) return const Center(child: CircularProgressIndicator());
    if (prov.error != null) {
      return const Center(child: Text('Error al cargar promociones'));
    }

    // Actualizamos el query en el provider para reutilizar su lógica
    // (si preferís no tocar el provider, filtrá localmente acá).
    prov.setQuery(_ctrl.text);
    final resultados = prov.filtrarFinal(prefs.seleccionadas);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Barra de búsqueda
          TextField(
            controller: _ctrl,
            decoration: InputDecoration(
              hintText: 'Buscar por banco, título o descripción...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _ctrl.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _ctrl.clear();
                        setState(() {}); // refresca la UI
                      },
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),

          // Conteo / feedback
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              resultados.isEmpty
                  ? 'Sin resultados'
                  : 'Resultados: ${resultados.length}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 8),

          // Lista de resultados con cards iguales al Home
          Expanded(
            child: resultados.isEmpty
                ? const _EmptyState()
                : ListView.separated(
                    itemCount: resultados.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final promo = resultados[i];
                      return PromoCard(
                        promo: promo,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PromotionDetailPage(promo: promo),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.search_off, size: 48),
          SizedBox(height: 8),
          Text('No encontramos promociones con ese criterio'),
          SizedBox(height: 4),
          Text('Probá con otro término o ajustá tus bancos/categorías',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
