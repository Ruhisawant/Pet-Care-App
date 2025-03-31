import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DogTip {
  final int? id;
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;

  DogTip({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory DogTip.fromMap(Map<String, dynamic> map) {
    return DogTip(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dog_tips.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dog_tips(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // Create a new tip
  Future<int> insertTip(DogTip tip) async {
    final db = await database;
    return await db.insert('dog_tips', tip.toMap());
  }

  // Get all tips
  Future<List<DogTip>> getAllTips() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dog_tips');
    return List.generate(maps.length, (i) => DogTip.fromMap(maps[i]));
  }

  // Get tips by category
  Future<List<DogTip>> getTipsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dog_tips',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => DogTip.fromMap(maps[i]));
  }

  // Get a single tip by id
  Future<DogTip?> getTip(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dog_tips',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return DogTip.fromMap(maps.first);
  }

  // Update a tip
  Future<int> updateTip(DogTip tip) async {
    final db = await database;
    return await db.update(
      'dog_tips',
      tip.toMap(),
      where: 'id = ?',
      whereArgs: [tip.id],
    );
  }

  // Delete a tip
  Future<int> deleteTip(int id) async {
    final db = await database;
    return await db.delete(
      'dog_tips',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get all categories
  Future<List<String>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dog_tips',
      distinct: true,
      columns: ['category'],
    );
    return List.generate(maps.length, (i) => maps[i]['category'] as String);
  }

  // Populate database with default tips
  Future<void> populateDefaultTips() async {
    final db = await database;
    final List<Map<String, dynamic>> existingTips = await db.query('dog_tips');
    
    if (existingTips.isEmpty) {
      final List<DogTip> defaultTips = [
        DogTip(
          title: 'Weight Management',
          content: 'Keep your pet at a healthy weight',
          category: 'Health',
          createdAt: DateTime.now(),
        ),
        DogTip(
          title: 'Exercise',
          content: 'Exercise your pet',
          category: 'Health',
          createdAt: DateTime.now(),
        ),
        DogTip(
          title: 'Nutrition',
          content: 'Feed your pet a balanced, nutritious diet',
          category: 'Health',
          createdAt: DateTime.now(),
        ),
        DogTip(
          title: 'Bonding',
          content: 'Touch your dog\'s nose',
          category: 'Bonding',
          createdAt: DateTime.now(),
        ),
        DogTip(
          title: 'Emergency Preparedness',
          content: 'Make a "pet first aid" kit',
          category: 'Safety',
          createdAt: DateTime.now(),
        ),
        DogTip(
          title: 'Insurance',
          content: 'Get pet insurance',
          category: 'Safety',
          createdAt: DateTime.now(),
        ),
        DogTip(
          title: 'Hygiene',
          content: 'Clean Bowls Daily',
          category: 'Hygiene',
          createdAt: DateTime.now(),
        ),
        DogTip(
          title: 'Grooming',
          content: 'Trim Nails',
          category: 'Grooming',
          createdAt: DateTime.now(),
        ),
        DogTip(
          title: 'Ear Care',
          content: 'Clean Ears',
          category: 'Grooming',
          createdAt: DateTime.now(),
        ),
        DogTip(
          title: 'Bathing',
          content: 'Bathe When Needed',
          category: 'Grooming',
          createdAt: DateTime.now(),
        ),
      ];

      for (var tip in defaultTips) {
        await insertTip(tip);
      }
    }
  }

  // Get a random tip
  Future<DogTip?> getRandomTip() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dog_tips');
    
    if (maps.isEmpty) return null;
    
    final random = DateTime.now().millisecondsSinceEpoch % maps.length;
    return DogTip.fromMap(maps[random]);
  }

  // Close the database
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
} 