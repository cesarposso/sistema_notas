class Materia {
  final String nombre;
  final int? creditos;
  final List<double> notas;

  Materia({
    required this.nombre,
    this.creditos,
    List<double>? notas,
  }) : notas = notas ?? [];

  void agregarNota(double nota) {
    if (nota < 0.0 || nota > 5.0) {
      throw ArgumentError('La nota debe estar entre 0.0 y 5.0');
    }
    notas.add(nota);
  }

  void eliminarNotaEn(int index) {
    if (index < 0 || index >= notas.length) {
      throw RangeError.index(index, notas, 'index');
    }
    notas.removeAt(index);
  }

  bool get tieneMinimoNotas => notas.length >= 3;

  double get promedio {
    if (notas.isEmpty) return 0.0;
    final sum = notas.fold<double>(0.0, (acc, n) => acc + n);
    return sum / notas.length;
  }

  bool get aprobada => promedio >= 3.0;
}

