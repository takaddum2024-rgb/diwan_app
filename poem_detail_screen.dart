import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/poem_provider.dart';
import '../providers/theme_provider.dart';
import '../models/poem.dart';
import '../widgets/audio_player_widget.dart';

class PoemDetailScreen extends StatefulWidget {
  final Poem poem;
  const PoemDetailScreen({super.key, required this.poem});

  @override
  State<PoemDetailScreen> createState() => _PoemDetailScreenState();
}

class _PoemDetailScreenState extends State<PoemDetailScreen> {
  late double _fontSize;
  late bool _isBold;
  String _selectedBgColor = 'default';
  String _selectedTextColor = 'auto';

  final List<Map<String, dynamic>> _backgroundColors = [
    {'name': 'افتراضي', 'color': 'default', 'textColor': 'auto'},
    {'name': 'أبيض', 'color': 'white', 'textColor': 'dark'},
    {'name': 'أصفر فاتح', 'color': '#FFF9C4', 'textColor': 'dark'},
    {'name': 'أخضر فاتح', 'color': '#C8E6C9', 'textColor': 'dark'},
    {'name': 'أزرق فاتح', 'color': '#BBDEFB', 'textColor': 'dark'},
    {'name': 'رمادي', 'color': '#E0E0E0', 'textColor': 'dark'},
    {'name': 'داكن', 'color': '#424242', 'textColor': 'white'},
  ];

  @override
  void initState() {
    super.initState();
    _fontSize = widget.poem.fontSize;
    _isBold = widget.poem.isBold;
  }

  @override
  Widget build(BuildContext context) {
    final poemProvider = Provider.of<PoemProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    // تحديد لون الخلفية
    Color bgColor;
    switch (_selectedBgColor) {
      case 'white':
        bgColor = Colors.white;
        break;
      case '#FFF9C4':
        bgColor = const Color(0xFFFFF9C4);
        break;
      case '#C8E6C9':
        bgColor = const Color(0xFFC8E6C9);
        break;
      case '#BBDEFB':
        bgColor = const Color(0xFFBBDEFB);
        break;
      case '#E0E0E0':
        bgColor = const Color(0xFFE0E0E0);
        break;
      case '#424242':
        bgColor = const Color(0xFF424242);
        break;
      default:
        bgColor =
            themeProvider.isDarkMode ? Colors.grey[900]! : Colors.transparent;
    }

    // تحديد لون النص
    Color textColor;
    if (_selectedTextColor == 'white') {
      textColor = Colors.white;
    } else if (_selectedTextColor == 'dark') {
      textColor = const Color(0xFF3E2723);
    } else {
      textColor =
          themeProvider.isDarkMode ? Colors.white : const Color(0xFF3E2723);
    }

    Color titleColor;
    if (_selectedTextColor == 'white') {
      titleColor = Colors.white;
    } else if (_selectedTextColor == 'dark') {
      titleColor = const Color(0xFF800000);
    } else {
      titleColor = themeProvider.isDarkMode
          ? const Color(0xFFFFD700)
          : const Color(0xFF800000);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.poem.title),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: const Color(0xFFFFD700),
        actions: [
          // زر المفضلة
          IconButton(
            icon: Icon(
              widget.poem.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.poem.isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              poemProvider.toggleFavorite(widget.poem.id!);
            },
          ),
          // زر قائمة الخيارات (تغيير الخط والخلفية)
          PopupMenuButton<String>(
            icon: const Icon(Icons.palette),
            onSelected: (value) {
              switch (value) {
                case 'font_size':
                  _showFontSizeDialog();
                  break;
                case 'bold':
                  setState(() => _isBold = !_isBold);
                  break;
                case 'background':
                  _showBackgroundDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'font_size',
                child: Row(
                  children: [
                    Icon(Icons.text_fields),
                    SizedBox(width: 8),
                    Text('تغيير حجم الخط'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'bold',
                child: Row(
                  children: [
                    Icon(Icons.format_bold),
                    SizedBox(width: 8),
                    Text('غامق / عادي'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'background',
                child: Row(
                  children: [
                    Icon(Icons.palette),
                    SizedBox(width: 8),
                    Text('تغيير الخلفية'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: bgColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // عنوان القصيدة
                Text(
                  widget.poem.title,
                  style: TextStyle(
                    fontSize: _fontSize * 1.5,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // اسم الشاعر
                Text(
                  widget.poem.poetName,
                  style: TextStyle(
                    fontSize: _fontSize * 1.2,
                    color: textColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 30),

                // نص القصيدة
                Text(
                  widget.poem.content,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                    height: 2.0,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 30),

                // مشغل الصوت - تمت الإضافة هنا
                if (widget.poem.audioUrl != null ||
                    widget.poem.audioPath != null)
                  AudioPlayerWidget(
                    audioPath: widget.poem.audioPath,
                    audioUrl: widget.poem.audioUrl,
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double tempSize = _fontSize;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('حجم الخط'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('حجم الخط الحالي: ${tempSize.round()}'),
                  const SizedBox(height: 8),
                  Text('معاينة', style: TextStyle(fontSize: tempSize)),
                  Slider(
                    value: tempSize,
                    min: 14,
                    max: 36,
                    divisions: 22,
                    label: tempSize.round().toString(),
                    onChanged: (value) {
                      setDialogState(() => tempSize = value);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _fontSize = tempSize);
                    Navigator.pop(context);
                  },
                  child: const Text('تأكيد'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBackgroundDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('اختيار لون الخلفية'),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _backgroundColors.map((bg) {
              Color displayColor;
              switch (bg['color']) {
                case 'white':
                  displayColor = Colors.white;
                  break;
                case '#FFF9C4':
                  displayColor = const Color(0xFFFFF9C4);
                  break;
                case '#C8E6C9':
                  displayColor = const Color(0xFFC8E6C9);
                  break;
                case '#BBDEFB':
                  displayColor = const Color(0xFFBBDEFB);
                  break;
                case '#E0E0E0':
                  displayColor = const Color(0xFFE0E0E0);
                  break;
                case '#424242':
                  displayColor = const Color(0xFF424242);
                  break;
                default:
                  displayColor = Colors.grey[200]!;
              }
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedBgColor = bg['color'];
                    _selectedTextColor = bg['textColor'];
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: displayColor,
                    border: Border.all(
                      color: _selectedBgColor == bg['color']
                          ? Colors.red
                          : Colors.grey,
                      width: _selectedBgColor == bg['color'] ? 3 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      bg['name'],
                      style: TextStyle(
                        fontSize: 10,
                        color: bg['color'] == '#424242'
                            ? Colors.white
                            : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
