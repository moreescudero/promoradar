import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/profile_option.dart';
import '../providers/users_pref_provider.dart';
import '../models/institucion.dart';
import '../services/institucion_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<Institucion>> _futureInst;

  @override
  void initState() {
    super.initState();
    _futureInst = InstitucionService.cargarInstituciones();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<UserPrefsProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---------- Cabecera (lo que ya tenías) ----------
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Morena Escudero',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'morena@email.com',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // ---------- Opciones (lo que ya tenías) ----------
          ProfileOption(
            title: 'Editar Perfil',
            icon: Icons.edit,
            onTap: () {
              // TODO: Navegar a edición de perfil
            },
          ),
          ProfileOption(
            title: 'Configuración',
            icon: Icons.settings,
            onTap: () {
              // TODO: Navegar a configuración
            },
          ),
          ProfileOption(
            title: 'Cerrar Sesión',
            icon: Icons.logout,
            onTap: () {
              // TODO: Implementar logout
            },
          ),

          const SizedBox(height: 24),

          // ---------- NUEVO: Selección de bancos/billeteras ----------
          Text(
            'Mis bancos y billeteras',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),

          // Estado del provider mientras carga las selecciones persistidas
          if (prefs.cargando)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            FutureBuilder<List<Institucion>>(
              future: _futureInst,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snap.hasError) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('Error al cargar instituciones'),
                  );
                }
                final insts = snap.data ?? [];
                if (insts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('No hay instituciones configuradas'),
                  );
                }

                // Chips seleccionables
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: insts.map((i) {
                    final selected = prefs.isSelected(i.id);
                    return FilterChip(
                      label: Text(i.nombre),
                      selected: selected,
                      onSelected: (_) => prefs.toggle(i.id),
                    );
                  }).toList(),
                );
              },
            ),

          const SizedBox(height: 12),
          Text(
            'Solo vas a ver promociones de las instituciones seleccionadas.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
