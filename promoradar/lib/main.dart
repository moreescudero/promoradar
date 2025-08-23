import 'package:flutter/material.dart';
import 'package:promoradar/providers/promociones_provider.dart';
import 'package:provider/provider.dart';

import 'providers/users_pref_provider.dart';
import 'screens/root_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PromocionesProvider()..init()),
      ChangeNotifierProvider(create: (_) => UserPrefsProvider()..init()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPage(),
    );
  }
}
