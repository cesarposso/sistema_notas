import 'package:flutter/material.dart';
import '../controllers/materias_controller.dart';
import '../models/materia.dart';
import 'detalle_materia_screen.dart';

class MateriasScreen extends StatefulWidget {
  final MateriasController controller;
  const MateriasScreen({super.key, required this.controller});

  @override
  State<MateriasScreen> createState() => _MateriasScreenState();
}

class _MateriasScreenState extends State<MateriasScreen> {
  Future<void> _mostrarDialogoAgregar() async {
    final nombreCtrl = TextEditingController();
    final creditosCtrl = TextEditingController();

    Future<void> showError(String msg) async {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Agregar materia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre (obligatorio)'),
              textInputAction: TextInputAction.next,
            ),
            TextField(
              controller: creditosCtrl,
              decoration: const InputDecoration(labelText: 'Créditos (opcional)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final nombre = nombreCtrl.text;
              int? creditos;

              final creditosText = creditosCtrl.text.trim();
              if (creditosText.isNotEmpty) {
                final parsed = int.tryParse(creditosText);
                if (parsed == null) {
                  await showError('Créditos debe ser un número entero.');
                  return;
                }
                creditos = parsed;
              }

              try {
                widget.controller.agregarMateria(nombre: nombre, creditos: creditos);
                if (mounted) {
                  setState(() {});
                  Navigator.pop(context);
                }
              } catch (e) {
                await showError(e.toString());
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _abrirDetalle(Materia materia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleMateriaScreen(
          controller: widget.controller,
          materia: materia,
          onChanged: () => setState(() {}),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final materias = widget.controller.materias;

    return Scaffold(
      appBar: AppBar(title: const Text('Sistema de Notas')),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoAgregar,
        child: const Icon(Icons.add),
      ),
      body: materias.isEmpty
          ? const Center(child: Text('No hay materias registradas'))
          : ListView.separated(
        itemCount: materias.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final m = materias[i];
          return ListTile(
            title: Text(m.nombre),
            subtitle: Text('Notas: ${m.notas.length} • Promedio: ${m.promedio.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => setState(() => widget.controller.eliminarMateria(m)),
            ),
            onTap: () => _abrirDetalle(m),
          );
        },
      ),
    );
  }
}
