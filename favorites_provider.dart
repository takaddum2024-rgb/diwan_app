import 'package:flutter/material.dart';
import '../models/poem.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(String poemId) => _favoriteIds.contains(poemId);

  void toggleFavorite(String poemId) {
    if (_favoriteIds.contains(poemId)) {
      _favoriteIds.remove(poemId);
    } else {
      _favoriteIds.add(poemId);
    }
    notifyListeners();
  }

  void removeFavorite(String poemId) {
    _favoriteIds.remove(poemId);
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteIds.clear();
    notifyListeners();
  }
}
