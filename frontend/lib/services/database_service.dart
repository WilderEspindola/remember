// lib/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../data/models/memory_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final String pathName = path.join(dbPath, 'remember.db');

    return await openDatabase(pathName, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE memories(
        id TEXT PRIMARY KEY,
        createdAt TEXT,
        objetoFotoFrontal TEXT,
        objetoFotoIzquierda TEXT,
        objetoFotoDerecha TEXT,
        tipoRecuerdo TEXT,
        contenidoPath TEXT,
        textoExtra TEXT,
        vecesEncontrado INTEGER,
        ultimoEncuentro TEXT
      )
    ''');
  }

  // Guardar un recuerdo
  Future<void> insertMemory(MemoryModel memory) async {
    final db = await database;
    await db.insert(
      'memories',
      memory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // En insertMemory, después de db.insert:
    print('Recuerdo guardado: ${memory.id} - ${memory.tipoRecuerdo}');
  }

  // Obtener todos los recuerdos
  Future<List<MemoryModel>> getAllMemories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('memories');

    return List.generate(maps.length, (i) {
      return MemoryModel.fromMap(maps[i]);
    });
  }

  // Obtener un recuerdo por ID
  Future<MemoryModel?> getMemoryById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'memories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MemoryModel.fromMap(maps.first);
    }
    return null;
  }

  // Actualizar veces encontrado
  Future<void> incrementFoundCount(String id) async {
    final db = await database;
    final memory = await getMemoryById(id);
    if (memory != null) {
      await db.update(
        'memories',
        {
          'vecesEncontrado': memory.vecesEncontrado + 1,
          'ultimoEncuentro': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // Eliminar un recuerdo
  Future<void> deleteMemory(String id) async {
    final db = await database;
    await db.delete('memories', where: 'id = ?', whereArgs: [id]);
  }

  // Cerrar base de datos
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
