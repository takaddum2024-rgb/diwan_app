import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/poem_provider.dart';
import '../providers/theme_provider.dart';
import '../models/poem.dart';
import 'poem_detail_screen.dart';
import 'drafts_screen.dart';
import 'about_screen.dart';
import 'contact_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PoemProvider>(context, listen: false).loadPoems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final poemProvider = Provider.of<PoemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ديوان القصائد'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF800000),
        foregroundColor: const Color(0xFFFFD700),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip:
                themeProvider.isDarkMode ? 'الوضع النهاري' : 'الوضع الليلي',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF800000), Color(0xFF4A0000)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    'ديوان القصائد',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'مكتبتك الشعرية',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading:
                  const Icon(Icons.library_books, color: Color(0xFF800000)),
              title: const Text('المكتبة'),
              selected: _currentIndex == 0,
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Color(0xFF800000)),
              title: const Text('المفضلة'),
              selected: _currentIndex == 1,
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_note, color: Color(0xFF800000)),
              title: const Text('قصائدي'),
              selected: _currentIndex == 2,
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add, color: Color(0xFF800000)),
              title: const Text('إضافة قصيدة جديدة'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DraftsScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF800000)),
              title: const Text('نبذة عن التطبيق'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: Color(0xFF800000)),
              title: const Text('اتصل بنا'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: poemProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _currentIndex,
              children: [
                PoemsList(poems: poemProvider.builtInPoems, isUserPoems: false),
                PoemsList(
                    poems: poemProvider.favoritePoems, isUserPoems: false),
                PoemsList(poems: poemProvider.userPoems, isUserPoems: true),
              ],
            ),
    );
  }
}

// ==================== قائمة القصائد ====================
class PoemsList extends StatelessWidget {
  final List<Poem> poems;
  final bool isUserPoems;

  const PoemsList({
    super.key,
    required this.poems,
    required this.isUserPoems,
  });

  @override
  Widget build(BuildContext context) {
    if (poems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUserPoems ? Icons.edit_note : Icons.menu_book,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isUserPoems ? 'لا توجد قصائد مضافة' : 'لا توجد قصائد',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            if (isUserPoems) ...[
              const SizedBox(height: 8),
              Text(
                'اضغط على زر + في القائمة لإضافة قصيدة',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: poems.length,
      itemBuilder: (context, index) {
        final poem = poems[index];
        return PoemCard(poem: poem, isUserPoem: isUserPoems);
      },
    );
  }
}

// ==================== بطاقة القصيدة ====================
class PoemCard extends StatelessWidget {
  final Poem poem;
  final bool isUserPoem;

  const PoemCard({
    super.key,
    required this.poem,
    required this.isUserPoem,
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PoemDetailScreen(poem: poem),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF800000),
                ),
                child: Icon(
                  isUserPoem ? Icons.edit_note : Icons.menu_book,
                  color: const Color(0xFFFFD700),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
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
                        color: Theme.of(context).primaryColor,
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
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      poem.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: poem.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      poemProvider.toggleFavorite(poem.id!);
                    },
                    tooltip:
                        poem.isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                  ),
                  if (isUserPoem)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteDialog(context, poemProvider, poem);
                      },
                      tooltip: 'حذف القصيدة',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, PoemProvider provider, Poem poem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف قصيدة'),
        content: Text('هل أنت متأكد من حذف "${poem.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await provider.deleteUserPoem(poem.id!);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف القصيدة بنجاح')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
