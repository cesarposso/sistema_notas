import 'package:flutter/material.dart';
import 'controllers/materias_controller.dart';
import 'screens/materias_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MateriasController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Notas',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: MateriasScreen(controller: controller),
    );
  }
}
