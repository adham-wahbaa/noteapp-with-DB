import 'package:alex4_db/model/note.dart';
import 'package:alex4_db/db/crud.dart';
import 'package:alex4_db/search/serves/search_method.dart';
import 'package:flutter/material.dart';

class SearchService {
  static List<Note> searchNotesByTitle(List<Note> allNotes, String searchQuery) {
    if (searchQuery.isEmpty) {
      return allNotes;
    }
    
    final query = searchQuery.toLowerCase().trim();
    return allNotes.where((note) {
      return note.title.toLowerCase().contains(query);
    }).toList();
  }

  static List<Note> searchNotesByContent(List<Note> allNotes, String searchQuery) {
    if (searchQuery.isEmpty) {
      return allNotes;
    }
    
    final query = searchQuery.toLowerCase().trim();
    return allNotes.where((note) {
      return note.content.toLowerCase().contains(query);
    }).toList();
  }

  static List<Note> searchNotes(List<Note> allNotes, String searchQuery) {
    if (searchQuery.isEmpty) {
      return allNotes;
    }
    
    final query = searchQuery.toLowerCase().trim();
    return allNotes.where((note) {
      return note.title.toLowerCase().contains(query) ||
             note.content.toLowerCase().contains(query);
    }).toList();
  }

  // Main search method that handles loading notes and filtering
  static Future<List<Note>> performSearch(String searchQuery) async {
    // Load all notes from database
    Crud.instance.selectAll();
    
    // Get current notes from notifier
    List<Note> allNotes = Crud.instance.noteNotifier.value;
    
    // Filter notes based on search query
    if (searchQuery.isEmpty) {
      return allNotes;
    }
    
    final query = searchQuery.toLowerCase().trim();
    return allNotes.where((note) {
      return note.title.toLowerCase().contains(query);
    }).toList();
  }

  // Method to get all notes
  static List<Note> getAllNotes() {
    Crud.instance.selectAll();
    return Crud.instance.noteNotifier.value;
  }

  // Create and setup SearchMethod with callbacks
  static SearchMethod createSearchMethod({
    required TextEditingController searchController,
    required Function(List<Note>) onSearchResults,
    required Function(bool) onSearchStateChanged,
  }) {
    return SearchMethod(
      searchController: searchController,
      onSearchResults: onSearchResults,
      onSearchStateChanged: onSearchStateChanged,
    );
  }
}
