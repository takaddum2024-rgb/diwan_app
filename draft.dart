class Draft {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? backgroundColor;
  final double fontSize;
  final bool isBold;

  Draft({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    DateTime? updatedAt,
    this.backgroundColor,
    this.fontSize = 18.0,
    this.isBold = false,
  }) : updatedAt = updatedAt ?? createdAt;

  Draft copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? backgroundColor,
    double? fontSize,
    bool? isBold,
  }) {
    return Draft(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontSize: fontSize ?? this.fontSize,
      isBold: isBold ?? this.isBold,
    );
  }
}
