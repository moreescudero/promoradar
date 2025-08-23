// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/promociones_provider.dart';
import '../providers/users_pref_provider.dart';
import '../models/promocion.dart';
import '../utils/bank_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const categorias = <String, String>{
    'supermercados': 'Supermercados',
    'restaurantes': 'Restaurantes',
    'cines': 'Cines',
    'electronica': 'Electrónica',
  };

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PromocionesProvider>();
    final prefs = context.watch<UserPrefsProvider>();

    if (prov.cargando || prefs.cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    final promos = prov.filtrarFinal(prefs.seleccionadas);
    if (promos.isEmpty) {
      return _EmptyState(onGoProfile: () {
        // sugerí navegar a Perfil desde Root si tenés un método; por ahora solo UI
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Elegí bancos en Perfil para ver promos')),
        );
      });
    }

    // 1) Agrupamos por banco/ID
    final grouped = _groupBy(promos, (Promocion p) => p.institucionId);

    return RefreshIndicator(
      onRefresh: () async {
        // si mañana conectás una API, llamás aquí a prov.refresh()
        await Future.delayed(const Duration(milliseconds: 600));
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _HomeHeader(),
            ),
          ),

          // Chips de categorías conectados al provider
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  for (final entry in categorias.entries)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Row(
                          children: [
                            Icon(_catIcon(entry.key), size: 18),
                            const SizedBox(width: 6),
                            Text(entry.value),
                          ],
                        ),
                        selected: prov.categoriaActiva(entry.key),
                        onSelected: (_) => prov.toggleCategoria(entry.key),
                      ),
                    ),
                  // Botón rápido para limpiar categorías
                  TextButton(
                    onPressed: prov.limpiarCategorias,
                    child: const Text('Limpiar filtros'),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Secciones por banco
          for (final entry in grouped.entries) ...[
            SliverToBoxAdapter(child: _SectionHeader(institucionId: entry.key)),
            SliverList.separated(
              itemCount: entry.value.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _PromoCard(promo: entry.value[i]),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  // Helper para agrupar
  Map<K, List<T>> _groupBy<T, K>(List<T> items, K Function(T) keyOf) {
    final map = <K, List<T>>{};
    for (final it in items) {
      final k = keyOf(it);
      map.putIfAbsent(k, () => []).add(it);
    }
    return map;
  }
} 

// iconito por categoría (simple)
IconData _catIcon(String catId) {
  switch (catId) {
    case 'supermercados': return Icons.local_grocery_store;
    case 'restaurantes':  return Icons.restaurant;
    case 'cines':         return Icons.movie;
    case 'electronica':   return Icons.devices_other;
    default:              return Icons.sell;
  }
}

// ---------- HEADER UI ----------
class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(radius: 28, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3')),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('¡Hola, More! 👋', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Estas son las mejores promos según tus bancos seleccionados.',
                      style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- CHIP FILTRO RÁPIDO (solo UI por ahora) ----------
class _QuickChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _QuickChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: false,
        onSelected: (_) {
          // acá podrías setear un filtro de categoría en el provider si lo agregás
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Filtro $label (demo)')));
        },
        label: Row(children: [Icon(icon, size: 18), const SizedBox(width: 6), Text(label)]),
      ),
    );
  }
}

// ---------- ENCABEZADO DE SECCIÓN POR BANCO ----------
class _SectionHeader extends StatelessWidget {
  final String institucionId;
  const _SectionHeader({required this.institucionId});

  @override
  Widget build(BuildContext context) {
    final style = bankStyles[institucionId];
    final name = style?.name ?? institucionId;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(
        children: [
          if (style?.logoAsset != null)
            Image.asset(style!.logoAsset!, height: 24),
          if (style?.logoAsset != null) const SizedBox(width: 8),
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: style?.color,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- CARD DE PROMO ----------
class _PromoCard extends StatelessWidget {
  final Promocion promo;
  const _PromoCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    final style = bankStyles[promo.institucionId];
    final color = style?.color ?? Theme.of(context).colorScheme.primary;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          // TODO: navegar a detalle de promo
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Detalle: ${promo.titulo} (demo)')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // avatar/logo
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

              // texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(promo.titulo,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(promo.descripcion, maxLines: 2, overflow: TextOverflow.ellipsis),
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

// ---------- TAG ----------
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

// ---------- EMPTY STATE ----------
class _EmptyState extends StatelessWidget {
  final VoidCallback onGoProfile;
  const _EmptyState({required this.onGoProfile});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.account_balance_wallet_outlined, size: 64),
            const SizedBox(height: 12),
            const Text('No hay promos para mostrar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const Text('Elegí tus bancos y billeteras desde Perfil.'),
            const SizedBox(height: 16),
            FilledButton(onPressed: onGoProfile, child: const Text('Ir a Perfil')),
          ],
        ),
      ),
    );
  }
}
