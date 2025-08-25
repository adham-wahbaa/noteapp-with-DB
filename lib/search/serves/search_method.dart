import 'package:flutter/material.dart';
import 'package:alex4_db/model/note.dart';
import 'package:alex4_db/search/serves/search.dart';

class SearchMethod {
  final TextEditingController searchController;
  final Function(List<Note>) onSearchResults;
  final Function(bool) onSearchStateChanged;
  
  List<Note> _filteredNotes = [];
  bool _isSearching = false;

  SearchMethod({
    required this.searchController,
    required this.onSearchResults,
    required this.onSearchStateChanged,
  }) {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() async {
    final query = searchController.text;
    
    if (query.isEmpty) {
      _isSearching = false;
      _filteredNotes = [];
      onSearchStateChanged(false);
      onSearchResults([]);
      return;
    }

    _isSearching = true;
    onSearchStateChanged(true);

    // Use the search method from SearchService
    final results = await SearchService.performSearch(query);
    
    _filteredNotes = results;
    onSearchResults(results);
  }

  void clearSearch() {
    searchController.clear();
    _isSearching = false;
    _filteredNotes = [];
    onSearchStateChanged(false);
    onSearchResults([]);
  }

  List<Note> get filteredNotes => _filteredNotes;
  bool get isSearching => _isSearching;

  void dispose() {
    // Don't dispose the controller as it's managed externally
  }
}
