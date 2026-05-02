import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/poem.dart';
import '../data/poems_data.dart';

class PoemProvider extends ChangeNotifier {
  List<Poem> _allPoems = [];
  List<Poem> _builtInPoems = [];
  List<Poem> _userPoems = [];
  List<Poem> _favoritePoems = [];

  bool _isLoading = true;

  List<Poem> get allPoems => _allPoems;
  List<Poem> get builtInPoems => _builtInPoems;
  List<Poem> get userPoems => _userPoems;
  List<Poem> get favoritePoems => _favoritePoems;
  bool get isLoading => _isLoading;

  Future<void> loadPoems() async {
    _isLoading = true;
    notifyListeners();

    _builtInPoems = _getBuiltInPoems();
    await _loadUserPoems();
    await _loadFavorites();

    _allPoems = [..._builtInPoems, ..._userPoems];
    _favoritePoems = _allPoems.where((p) => p.isFavorite).toList();

    _isLoading = false;
    notifyListeners();

    print('✅ تم تحميل ${_builtInPoems.length} قصيدة مثبتة');
    print('✅ تم تحميل ${_userPoems.length} قصيدة للمستخدم');
  }

  // 👈 هذا هو الشكل الصحيح للخيار 1
  List<Poem> _getBuiltInPoems() {
    return PoemsData.getPoems();
  }

  // باقي الكود (تحميل قصائد المستخدم، المفضلة، إلخ) يبقى كما هو...

  Future<void> _loadUserPoems() async {
    final prefs = await SharedPreferences.getInstance();
    final userPoemsJson = prefs.getStringList('user_poems');

    _userPoems = [];
    if (userPoemsJson != null) {
      for (int i = 0; i < userPoemsJson.length; i++) {
        final parts = userPoemsJson[i].split('|');
        if (parts.length == 3) {
          _userPoems.add(Poem(
            id: 1000 + i,
            title: parts[0],
            poetName: parts[1],
            content: parts[2],
            isBuiltIn: false,
          ));
        }
      }
    }
  }

  Future<void> _saveUserPoems() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> userPoemsJson = [];
    for (var poem in _userPoems) {
      userPoemsJson.add('${poem.title}|${poem.poetName}|${poem.content}');
    }
    await prefs.setStringList('user_poems', userPoemsJson);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    for (var poem in _builtInPoems) {
      poem.isFavorite = favorites.contains(poem.id.toString());
    }
    for (var poem in _userPoems) {
      poem.isFavorite = favorites.contains(poem.id.toString());
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = [];

    for (var poem in _builtInPoems) {
      if (poem.isFavorite) favorites.add(poem.id.toString());
    }
    for (var poem in _userPoems) {
      if (poem.isFavorite) favorites.add(poem.id.toString());
    }
    await prefs.setStringList('favorites', favorites);
  }

  Future<void> addUserPoem({
    required String title,
    required String poetName,
    required String content,
  }) async {
    final newId = 1000 + _userPoems.length;
    final newPoem = Poem(
      id: newId,
      title: title,
      poetName: poetName,
      content: content,
      isBuiltIn: false,
    );

    _userPoems.add(newPoem);
    await _saveUserPoems();
    await loadPoems();
  }

  Future<void> deleteUserPoem(int id) async {
    _userPoems.removeWhere((p) => p.id == id);
    await _saveUserPoems();
    await loadPoems();
  }

  Future<void> toggleFavorite(int id) async {
    for (var poem in _builtInPoems) {
      if (poem.id == id) {
        poem.isFavorite = !poem.isFavorite;
        await _saveFavorites();
        await loadPoems();
        return;
      }
    }
    for (var poem in _userPoems) {
      if (poem.id == id) {
        poem.isFavorite = !poem.isFavorite;
        await _saveFavorites();
        await loadPoems();
        return;
      }
    }
  }
}
