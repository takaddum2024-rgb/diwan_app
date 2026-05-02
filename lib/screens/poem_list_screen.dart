import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/poem_provider.dart';
import '../widgets/poem_card.dart';
import 'poem_detail_screen.dart';

class PoemListScreen extends StatefulWidget {
  const PoemListScreen({super.key});

  @override
  State<PoemListScreen> createState() => _PoemListScreenState();
}

class _PoemListScreenState extends State<PoemListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final poemProvider = Provider.of<PoemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'ابحث عن قصيدة...',
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.7),
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  poemProvider.setSearchQuery(value);
                },
              )
            : const Text('القصائد'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  poemProvider.setSearchQuery('');
                }
              });
            },
          ),
        ],
      ),
      body: poemProvider.poems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book,
                    size: 80,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد قصائد بعد',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'أضف أول قصيدة لك',
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
              itemCount: poemProvider.poems.length,
              itemBuilder: (context, index) {
                final poem = poemProvider.poems[index];
                return PoemCard(
                  poem: poem,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PoemDetailScreen(poem: poem),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
