// lib/data/models/memory_model.dart
class MemoryModel {
  final String id;
  final DateTime createdAt;
  final String objetoFotoFrontal;
  final String objetoFotoIzquierda;
  final String objetoFotoDerecha;
  final String tipoRecuerdo; // 'video', 'texto', 'foto'
  final String contenidoPath; // Ruta del video, texto, o foto adicional
  final String? textoExtra;   // Solo si tipoRecuerdo es 'texto'
  int vecesEncontrado;
  DateTime? ultimoEncuentro;

  MemoryModel({
    required this.id,
    required this.createdAt,
    required this.objetoFotoFrontal,
    required this.objetoFotoIzquierda,
    required this.objetoFotoDerecha,
    required this.tipoRecuerdo,
    required this.contenidoPath,
    this.textoExtra,
    this.vecesEncontrado = 0,
    this.ultimoEncuentro,
  });

  // Convertir a Map para guardar en base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'objetoFotoFrontal': objetoFotoFrontal,
      'objetoFotoIzquierda': objetoFotoIzquierda,
      'objetoFotoDerecha': objetoFotoDerecha,
      'tipoRecuerdo': tipoRecuerdo,
      'contenidoPath': contenidoPath,
      'textoExtra': textoExtra,
      'vecesEncontrado': vecesEncontrado,
      'ultimoEncuentro': ultimoEncuentro?.toIso8601String(),
    };
  }

  // Crear desde Map (para leer de base de datos)
  factory MemoryModel.fromMap(Map<String, dynamic> map) {
    return MemoryModel(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      objetoFotoFrontal: map['objetoFotoFrontal'],
      objetoFotoIzquierda: map['objetoFotoIzquierda'],
      objetoFotoDerecha: map['objetoFotoDerecha'],
      tipoRecuerdo: map['tipoRecuerdo'],
      contenidoPath: map['contenidoPath'],
      textoExtra: map['textoExtra'],
      vecesEncontrado: map['vecesEncontrado'] ?? 0,
      ultimoEncuentro: map['ultimoEncuentro'] != null 
          ? DateTime.parse(map['ultimoEncuentro']) 
          : null,
    );
  }
}