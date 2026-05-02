import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/draft.dart';
import '../providers/draft_provider.dart';
import 'add_draft_screen.dart';

class DraftDetailScreen extends StatefulWidget {
  final Draft draft;

  const DraftDetailScreen({super.key, required this.draft});

  @override
  State<DraftDetailScreen> createState() => _DraftDetailScreenState();
}

class _DraftDetailScreenState extends State<DraftDetailScreen> {
  late double _fontSize;
  late bool _isBold;
  String _selectedColor = 'default';

  final List<Map<String, dynamic>> _backgroundColors = [
    {'name': 'افتراضي', 'color': 'default'},
    {'name': 'أبيض', 'color': 'white'},
    {'name': 'أصفر فاتح', 'color': '#FFF9C4'},
    {'name': 'أخضر فاتح', 'color': '#C8E6C9'},
    {'name': 'أزرق فاتح', 'color': '#BBDEFB'},
    {'name': 'رمادي', 'color': '#E0E0E0'},
    {'name': 'داكن', 'color': '#424242'},
  ];

  @override
  void initState() {
    super.initState();
    _fontSize = widget.draft.fontSize;
    _isBold = widget.draft.isBold;
    _selectedColor = widget.draft.backgroundColor ?? 'default';
  }

  @override
  Widget build(BuildContext context) {
    final draftProvider = Provider.of<DraftProvider>(context);

    Color bgColor = Colors.transparent;
    switch (_selectedColor) {
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
        bgColor = Colors.transparent;
    }

    bool isDarkBg = _selectedColor == '#424242';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
            widget.draft.title.isEmpty ? 'بدون عنوان' : widget.draft.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddDraftScreen(draft: widget.draft),
                ),
              );
            },
            tooltip: 'تعديل',
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'font_size',
                child: Text('تغيير حجم الخط'),
              ),
              const PopupMenuItem(
                value: 'bold',
                child: Text('غامق / عادي'),
              ),
              const PopupMenuItem(
                value: 'background',
                child: Text('تغيير الخلفية'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('حذف المسودة'),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'font_size':
                  _showFontSizeDialog();
                  break;
                case 'bold':
                  setState(() {
                    _isBold = !_isBold;
                    draftProvider.updateTextStyle(
                      widget.draft.id,
                      isBold: _isBold,
                    );
                  });
                  break;
                case 'background':
                  _showBackgroundDialog();
                  break;
                case 'delete':
                  _deleteDraft();
                  break;
              }
            },
          ),
        ],
      ),
      body: Container(
        color: bgColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.draft.title.isNotEmpty) ...[
                Text(
                  widget.draft.title,
                  style: TextStyle(
                    fontSize: _fontSize * 1.5,
                    fontWeight: FontWeight.bold,
                    color: isDarkBg ? Colors.white : null,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                widget.draft.content,
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  height: 2.0,
                  color: isDarkBg ? Colors.white : null,
                ),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 8),
              Text(
                'تم الإنشاء: ${widget.draft.createdAt.day}/${widget.draft.createdAt.month}/${widget.draft.createdAt.year}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              if (widget.draft.updatedAt != widget.draft.createdAt)
                Text(
                  'آخر تعديل: ${widget.draft.updatedAt.day}/${widget.draft.updatedAt.month}/${widget.draft.updatedAt.year}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
            ],
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
                  Slider(
                    value: tempSize,
                    min: 14,
                    max: 36,
                    divisions: 22,
                    label: tempSize.round().toString(),
                    onChanged: (value) {
                      setDialogState(() {
                        tempSize = value;
                      });
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
                    setState(() {
                      _fontSize = tempSize;
                    });
                    Provider.of<DraftProvider>(context, listen: false)
                        .updateTextStyle(widget.draft.id, fontSize: _fontSize);
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
                  setState(() => _selectedColor = bg['color']);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: displayColor,
                    border: Border.all(
                      color: _selectedColor == bg['color']
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      width: _selectedColor == bg['color'] ? 3 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      bg['name'],
                      style: TextStyle(
                        fontSize: 12,
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

  void _deleteDraft() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف المسودة'),
        content: const Text(
            'هل أنت متأكد من حذف هذه المسودة؟ لا يمكن التراجع عن هذا الإجراء.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<DraftProvider>(context, listen: false)
                  .deleteDraft(widget.draft.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
