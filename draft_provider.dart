import 'package:flutter/material.dart';
import '../models/draft.dart';

class DraftProvider extends ChangeNotifier {
  final List<Draft> _drafts = [];
  List<Draft> _filteredDrafts = [];
  String _searchQuery = '';

  List<Draft> get drafts => _searchQuery.isEmpty ? _drafts : _filteredDrafts;

  void addDraft(Draft draft) {
    _drafts.insert(0, draft); // الأحدث أولاً
    _filterDrafts();
    notifyListeners();
    debugPrint('تمت إضافة مسودة: ${draft.title}');
    debugPrint('عدد المسودات: ${_drafts.length}');
  }

  void updateDraft(String id, Draft updatedDraft) {
    final index = _drafts.indexWhere((draft) => draft.id == id);
    if (index != -1) {
      _drafts[index] = updatedDraft;
      _filterDrafts();
      notifyListeners();
    }
  }

  void deleteDraft(String id) {
    _drafts.removeWhere((draft) => draft.id == id);
    _filterDrafts();
    notifyListeners();
  }

  void updateTextStyle(String id, {double? fontSize, bool? isBold}) {
    final index = _drafts.indexWhere((draft) => draft.id == id);
    if (index != -1) {
      _drafts[index] = _drafts[index].copyWith(
        fontSize: fontSize,
        isBold: isBold,
      );
      notifyListeners();
    }
  }

  void updateBackgroundColor(String id, String color) {
    final index = _drafts.indexWhere((draft) => draft.id == id);
    if (index != -1) {
      _drafts[index] = _drafts[index].copyWith(backgroundColor: color);
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterDrafts();
    notifyListeners();
  }

  void _filterDrafts() {
    if (_searchQuery.isEmpty) {
      _filteredDrafts = List.from(_drafts);
    } else {
      _filteredDrafts = _drafts.where((draft) {
        return draft.title.contains(_searchQuery) ||
            draft.content.contains(_searchQuery);
      }).toList();
    }
  }
}
