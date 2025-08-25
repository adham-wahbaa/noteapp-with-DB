import 'package:flutter/material.dart';
import 'package:alex4_db/search/serves/search.dart';
import 'package:alex4_db/db/crud.dart';
import 'package:alex4_db/model/note.dart';

class SearchBarWidget extends StatefulWidget {
  final VoidCallback? onBackPressed;
  final String hintText;

  const SearchBarWidget({
    super.key,
    this.onBackPressed,
    this.hintText = 'Search for note',
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Note> _allNotes = [];
  List<Note> _filteredNotes = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadNotes();
    // Initialize search state manager with all notes
    SearchStateManager().updateSearchState(false, []);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadNotes() {
    Crud.instance.selectAll();
    Crud.instance.noteNotifier.addListener(() {
      setState(() {
        _allNotes = Crud.instance.noteNotifier.value;
        _filteredNotes = _allNotes;
      });
      print('SearchBarWidget: Loaded ${_allNotes.length} notes from database');
      // Update search state manager with new notes when not searching
      if (!_isSearching) {
        SearchStateManager().updateSearchState(false, _allNotes);
      }
    });
  }

  void _onSearchChanged() async {
    final query = _searchController.text;
    
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredNotes = _allNotes;
      });
      print('SearchBarWidget: Search cleared, showing all ${_allNotes.length} notes');
      // Update global search state with all notes
      SearchStateManager().updateSearchState(false, _allNotes);
      return;
    }

    setState(() {
      _isSearching = true;
    });

    print('SearchBarWidget: Searching for "$query" in ${_allNotes.length} notes');

    // Use the search method from SearchService
    final results = await SearchService.performSearch(query);
    
    setState(() {
      _filteredNotes = results;
    });
    
    print('SearchBarWidget: Search results: ${results.length} notes found');
    
    // Update global search state with filtered results
    SearchStateManager().updateSearchState(true, results);
  }

  void _updateGlobalSearchState(bool isSearching, List<Note> notes) {
    // This will be used to communicate with NoteList
    SearchStateManager().updateSearchState(isSearching, notes);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _filteredNotes = _allNotes;
    });
    SearchStateManager().updateSearchState(false, _allNotes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Back arrow
            if (widget.onBackPressed != null)
              GestureDetector(
                onTap: widget.onBackPressed,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            if (widget.onBackPressed != null) const SizedBox(width: 12),

            // Search bar
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: _clearSearch,
                        child: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        // Search Results Info
        if (_isSearching)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Found ${_filteredNotes.length} note(s)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

// Simple global state manager for search
class SearchStateManager {
  static final SearchStateManager _instance = SearchStateManager._internal();
  factory SearchStateManager() => _instance;
  SearchStateManager._internal();

  static SearchStateManager get instance => _instance;

  bool _isSearching = false;
  List<Note> _filteredNotes = [];
  final List<Function(bool, List<Note>)> _listeners = [];

  void addListener(Function(bool, List<Note>) listener) {
    _listeners.add(listener);
  }

  void removeListener(Function(bool, List<Note>) listener) {
    _listeners.remove(listener);
  }

  void updateSearchState(bool isSearching, List<Note> notes) {
    _isSearching = isSearching;
    _filteredNotes = notes;
    
    print('SearchStateManager: Updating state - isSearching=$isSearching, notes count=${notes.length}');
    
    // Notify all listeners
    for (final listener in _listeners) {
      listener(isSearching, notes);
    }
  }

  bool get isSearching => _isSearching;
  List<Note> get filteredNotes => _filteredNotes;
}
