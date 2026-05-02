class Poem {
  final int? id;
  final String title;
  final String poetName;
  final String content;
  final bool isBuiltIn;
  bool isFavorite;
  final double fontSize;
  final bool isBold;
  final String? audioPath;
  final String? audioUrl;
  final String? category;
  final String? era;

  Poem({
    this.id,
    required this.title,
    required this.poetName,
    required this.content,
    this.isBuiltIn = true,
    this.isFavorite = false,
    this.fontSize = 20,
    this.isBold = false,
    this.audioPath,
    this.audioUrl,
    this.category,
    this.era,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'poetName': poetName,
      'content': content,
      'isBuiltIn': isBuiltIn ? 1 : 0,
      'isFavorite': isFavorite ? 1 : 0,
      'fontSize': fontSize,
      'isBold': isBold ? 1 : 0,
      'audioPath': audioPath,
      'audioUrl': audioUrl,
      'category': category,
      'era': era,
    };
  }

  factory Poem.fromMap(Map<String, dynamic> map) {
    return Poem(
      id: map['id'],
      title: map['title'],
      poetName: map['poetName'],
      content: map['content'],
      isBuiltIn: map['isBuiltIn'] == 1,
      isFavorite: map['isFavorite'] == 1,
      fontSize: (map['fontSize'] ?? 20).toDouble(),
      isBold: map['isBold'] == 1,
      audioPath: map['audioPath'],
      audioUrl: map['audioUrl'],
      category: map['category'],
      era: map['era'],
    );
  }

  Poem copyWith({
    int? id,
    String? title,
    String? poetName,
    String? content,
    bool? isBuiltIn,
    bool? isFavorite,
    double? fontSize,
    bool? isBold,
    String? audioPath,
    String? audioUrl,
    String? category,
    String? era,
  }) {
    return Poem(
      id: id ?? this.id,
      title: title ?? this.title,
      poetName: poetName ?? this.poetName,
      content: content ?? this.content,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      isFavorite: isFavorite ?? this.isFavorite,
      fontSize: fontSize ?? this.fontSize,
      isBold: isBold ?? this.isBold,
      audioPath: audioPath ?? this.audioPath,
      audioUrl: audioUrl ?? this.audioUrl,
      category: category ?? this.category,
      era: era ?? this.era,
    );
  }
}
