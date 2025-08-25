import 'package:alex4_db/db/crud.dart';
import 'package:alex4_db/model/note.dart';
import 'package:alex4_db/util/date_time_manager.dart';
import 'package:alex4_db/util/extension/context_extension.dart';
import 'package:alex4_db/widgets/edit_dialog.dart';
import 'package:alex4_db/search/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  bool _isSearching = false;
  List<Note> _filteredNotes = [];
  List<Note> _allNotes = [];

  @override
  void initState() {
    super.initState();
    getAllNotes();
    // Listen to search state changes
    SearchStateManager().addListener(_onSearchStateChanged);
  }

  @override
  void dispose() {
    SearchStateManager().removeListener(_onSearchStateChanged);
    super.dispose();
  }

  void _onSearchStateChanged(bool isSearching, List<Note> notes) {
    setState(() {
      _isSearching = isSearching;
      _filteredNotes = notes;
      print('Search state changed: isSearching=$isSearching, notes count=${notes.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Note>>(
      valueListenable: Crud.instance.noteNotifier,
      builder: (context, notes, child) {
        // Always update all notes from database
        _allNotes = notes;
        
        // Use filtered notes when searching, otherwise use all notes from database
        final notesToDisplay = _isSearching ? _filteredNotes : _allNotes;
        
        print('Building NoteList: isSearching=$_isSearching, allNotes=${_allNotes.length}, filteredNotes=${_filteredNotes.length}, notesToDisplay=${notesToDisplay.length}');
        
        return _buildNoteList(notesToDisplay);
      },
    );
  }

  Widget _buildNoteList(List<Note> notes) {
    if (notes.isEmpty) {
      if (_isSearching) {
        return Center(child: Text('No notes found matching your search'));
      } else {
        return Center(child: Text('No Data Found'));
      }
    }
    
    return ListView.separated(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.note_add),
        title: Text(notes[index].title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notes[index].content),
            if (notes[index].updatedAt == null)
              Text(
                'Created at: ${DateTimeManager.formateDate(notes[index].createdAt!)}',
              )
            else
              Text(
                'Updated at: ${DateTimeManager.formateDate(notes[index].updatedAt!)}',
              ),
          ],
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  deleteNote(notes[index].id!);
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
              IconButton(
                onPressed: () {
                  editNoteDialog(notes[index]);
                },
                icon: Icon(Icons.edit, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
      separatorBuilder: (context, index) =>
          Divider(color: Colors.white70, indent: 30, endIndent: 30),
      itemCount: notes.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  void getAllNotes() {
    Crud.instance.selectAll();
  }

  void deleteNote(int i) {
    Crud.instance.delete(i);
    context.showSnackBar('Note deleted successfully!');
  }

  void editNoteDialog(Note note) {
    showDialog(
      context: context,
      builder: (context) => EditDialog(note: note),
    );
  }
}
