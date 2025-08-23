import 'package:flutter/material.dart';
import 'package:promoradar/providers/users_pref_provider.dart';
import 'package:provider/provider.dart';

import '../providers/promociones_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<PromocionesProvider>();
    final prefs = context.watch<UserPrefsProvider>();

    final lista = prov.filtrar(prefs.seleccionadas, _ctrl.text);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _ctrl,
            decoration: const InputDecoration(
              hintText: 'Buscar en tus bancos/billeteras...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: lista.isEmpty
              ? const Center(child: Text('Sin resultados (revisá Perfil)'))
              : ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (_, i) {
                    final p = lista[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text('${p.banco} — ${p.titulo}'),
                        subtitle: Text(p.descripcion),
                        trailing: Text('Hasta\n${p.vigencia}', textAlign: TextAlign.right),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
