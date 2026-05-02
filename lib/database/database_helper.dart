import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/poem.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'diwan_poems.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // إنشاء جدول القصائد
    await db.execute('''
      CREATE TABLE poems(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        poetName TEXT NOT NULL,
        content TEXT NOT NULL,
        isBuiltIn INTEGER DEFAULT 1,
        isFavorite INTEGER DEFAULT 0,
        fontSize REAL DEFAULT 20,
        isBold INTEGER DEFAULT 0,
        audioPath TEXT,
        audioUrl TEXT,
        category TEXT,
        era TEXT
      )
    ''');

    // إضافة فهارس للبحث السريع
    await db.execute('CREATE INDEX idx_title ON poems(title)');
    await db.execute('CREATE INDEX idx_poetName ON poems(poetName)');

    // إدخال القصائد المثبتة
    await _insertBuiltInPoems(db);
  }

  Future<void> _insertBuiltInPoems(Database db) async {
    final builtInPoems = [
      {
        'title': 'قصيدة الأمل',
        'poetName': 'أبو القاسم الشابي',
        'content':
            'إذا الشعب يوما أراد الحياة\nفلا بد أن يستجيب القدر\nولا بد للليل أن ينجلي\nولا بد للقيد أن ينكسر',
        'isBuiltIn': 1,
        'category': 'حديثة',
        'era': 'الحديث',
        'audioUrl':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      },
      {
        'title': 'قصيدة الحب',
        'poetName': 'نزار قباني',
        'content':
            'أحبك جداً\nوأعرف أن الطريق إلى المستحيل طويل\nوأعرف أنك ست النساء\nوليس لدي بديل',
        'isBuiltIn': 1,
        'category': 'حب',
        'era': 'الحديث',
        'audioUrl':
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      },
      {
        'title': 'قصيدة الحب',
        'poetName': 'نزار قباني',
        'content':
            'أحبك جداً\nوأعرف أن الطريق إلى المستحيل طويل\nوأعرف أنك ست النساء\nوليس لدي بديل',
        'category': 'حب',
        'era': 'الحديث',
      },
      {
        'title': 'يا على سندن مدد',
        'poetName': 'محمد حسين الخطيب اللنكراني (عارف)',
        'content': '''دفتر يمده إسمٍ مولى عين بسمِ اللّهدور
في الحقيقت كيم سالورسه تفرقة كَمراهِدور
أى أميرِ مُلكِ بطحا      يا على سندن مدد
أى دبيرِ نظم أشيا       يا على سندن مدد
أى وزيرِ ثقلِ طه         يا على سندن مدد
طبعيمى قيل مدحه كويا يا على سندن مدد

مدحِ مولىٰ أمرٍ مشكلدور بضاعت أولماسه
ربِّ عزَّتدن أكَر لطف و عنايت أولماسه
مادحه تأييد سلطانٍ ولايت أولماسه
روحِ قدسْ ئيتمزْسه إلقا يا على سندن مدد

مُشكلى آسان نيدن أمره هدايت تاپمشام
سهلْ ئيدن إسم على شاهِ ولايت تاپمشام
يا على هر كيم ديسه ايله ر حمايت تاپمشام
كيمِيادور إسمٍ مولىٰ يا على سندن مدد''',
        'isBuiltIn': 1,
        'category': 'دينية',
        'era': 'معاصر',
        'audioUrl': null,
      },
    ];

    for (var poem in builtInPoems) {
      await db.insert('poems', poem);
    }
  }

  // ====================== عمليات القراءة ======================

  Future<List<Poem>> getAllPoems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('poems', orderBy: 'id');
    return List.generate(maps.length, (i) => Poem.fromMap(maps[i]));
  }

  Future<List<Poem>> getBuiltInPoems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'poems',
      where: 'isBuiltIn = ?',
      whereArgs: [1],
      orderBy: 'id',
    );
    return List.generate(maps.length, (i) => Poem.fromMap(maps[i]));
  }

  Future<List<Poem>> getUserPoems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'poems',
      where: 'isBuiltIn = ?',
      whereArgs: [0],
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => Poem.fromMap(maps[i]));
  }

  Future<List<Poem>> getFavoritePoems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'poems',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'title',
    );
    return List.generate(maps.length, (i) => Poem.fromMap(maps[i]));
  }

  // ====================== عمليات الكتابة ======================

  Future<int> insertPoem(Poem poem) async {
    final db = await database;
    return await db.insert('poems', poem.toMap());
  }

  Future<Poem> addUserPoem({
    required String title,
    required String poetName,
    required String content,
    String? category,
    String? era,
  }) async {
    final newPoem = Poem(
      title: title,
      poetName: poetName,
      content: content,
      isBuiltIn: false,
      category: category,
      era: era,
    );
    final id = await insertPoem(newPoem);
    return newPoem.copyWith(id: id);
  }

  Future<void> toggleFavorite(int id, bool currentValue) async {
    final db = await database;
    await db.update(
      'poems',
      {'isFavorite': currentValue ? 0 : 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePoem(int id) async {
    final db = await database;
    return await db.delete(
      'poems',
      where: 'id = ? AND isBuiltIn = ?',
      whereArgs: [id, 0],
    );
  }
}
