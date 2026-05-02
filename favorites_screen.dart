import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/poem_provider.dart';
import '../widgets/poem_card.dart';
import 'poem_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final poemProvider = Provider.of<PoemProvider>(context);
    final favorites = poemProvider.getFavorites();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('المفضلة ❤️'),
        actions: [
          if (favorites.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('مسح المفضلة'),
                    content:
                        const Text('هل تريد إزالة جميع القصائد من المفضلة؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          for (var poem in favorites) {
                            poemProvider.toggleFavorite(poem.id);
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('تأكيد'),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'مسح الكل',
            ),
        ],
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد قصائد مفضلة',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'أضف القصائد التي تعجبك إلى المفضلة',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final poem = favorites[index];
                return Dismissible(
                  key: Key(poem.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    poemProvider.toggleFavorite(poem.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تمت إزالة "${poem.title}" من المفضلة'),
                        action: SnackBarAction(
                          label: 'تراجع',
                          onPressed: () {
                            poemProvider.toggleFavorite(poem.id);
                          },
                        ),
                      ),
                    );
                  },
                  child: PoemCard(
                    poem: poem,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PoemDetailScreen(poem: poem),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
