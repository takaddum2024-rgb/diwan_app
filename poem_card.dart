import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/poem.dart';
import '../providers/poem_provider.dart';

class PoemCard extends StatelessWidget {
  final Poem poem;
  final VoidCallback onTap;
  final bool showDeleteButton;
  final VoidCallback? onDelete;

  const PoemCard({
    super.key,
    required this.poem,
    required this.onTap,
    this.showDeleteButton = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final poemProvider = Provider.of<PoemProvider>(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // أيقونة الكتاب أو القلم
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF800000),
                ),
                child: Icon(
                  poem.isBuiltIn ? Icons.menu_book : Icons.edit_note,
                  color: const Color(0xFFFFD700),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // معلومات القصيدة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      poem.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      poem.poetName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      poem.content.split('\n').first,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // أزرار التحكم
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      poem.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: poem.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      poemProvider.toggleFavorite(poem.id!, poem.isFavorite);
                    },
                    tooltip:
                        poem.isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                  ),
                  if (showDeleteButton && onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                      tooltip: 'حذف القصيدة',
                    ),
                  if (poem.audioPath != null || poem.audioUrl != null)
                    Icon(
                      Icons.headphones,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
