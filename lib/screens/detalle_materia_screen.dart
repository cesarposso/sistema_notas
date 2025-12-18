import 'package:flutter/material.dart';
import '../controllers/materias_controller.dart';
import '../models/materia.dart';

class DetalleMateriaScreen extends StatefulWidget {
  final MateriasController controller;
  final Materia materia;
  final VoidCallback onChanged;

  const DetalleMateriaScreen({
    super.key,
    required this.controller,
    required this.materia,
    required this.onChanged,
  });

  @override
  State<DetalleMateriaScreen> createState() => _DetalleMateriaScreenState();
}

class _DetalleMateriaScreenState extends State<DetalleMateriaScreen> {
  final _notaCtrl = TextEditingController();

  Future<void> _showError(String msg) async {
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

  Future<void> _agregarNota() async {
    final raw = _notaCtrl.text.trim().replaceAll(',', '.');
    final nota = double.tryParse(raw);

    if (nota == null) {
      await _showError('Ingresa una nota válida (ej: 4.5).');
      return;
    }

    try {
      widget.controller.agregarNota(widget.materia, nota);
      _notaCtrl.clear();
      setState(() {});
      widget.onChanged();
    } catch (e) {
      await _showError(e.toString());
    }
  }

  @override
  void dispose() {
    _notaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.materia;

    final promedioText = m.promedio.toStringAsFixed(2);
    final estado = m.aprobada ? 'Aprobada' : 'Reprobada';
    final estadoColor = m.aprobada ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(title: Text(m.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (m.creditos != null) Text('Créditos: ${m.creditos}'),
            const SizedBox(height: 8),

            Text('Promedio: $promedioText'),
            const SizedBox(height: 4),

            Row(
              children: [
                const Text('Estado: '),
                Text(
                  estado,
                  style: TextStyle(color: estadoColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (!m.tieneMinimoNotas)
              const Text(
                'Faltan notas: debes registrar mínimo 3.',
                style: TextStyle(color: Colors.orange),
              ),

            const Divider(height: 24),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _notaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nueva nota (0.0 - 5.0)',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onSubmitted: (_) => _agregarNota(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _agregarNota,
                  child: const Text('Agregar'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text('Notas:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            Expanded(
              child: m.notas.isEmpty
                  ? const Text('Aún no hay notas registradas.')
                  : ListView.separated(
                itemCount: m.notas.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => ListTile(
                  title: Text('Nota ${i + 1}: ${m.notas[i].toStringAsFixed(2)}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
