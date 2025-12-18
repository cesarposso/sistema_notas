import '../models/materia.dart';

class MateriasController {
  final List<Materia> materias = [];

  void agregarMateria({required String nombre, int? creditos}) {
    final clean = nombre.trim();
    if (clean.isEmpty) {
      throw ArgumentError('El nombre no puede estar vacío');
    }
    materias.add(Materia(nombre: clean, creditos: creditos));
  }

  void eliminarMateria(Materia materia) {
    materias.remove(materia);
  }

  void agregarNota(Materia materia, double nota) {
    materia.agregarNota(nota);
  }

  void eliminarNota(Materia materia, int index) {
    materia.eliminarNotaEn(index);
  }
}

