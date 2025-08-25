import 'package:alex4_db/db/crud.dart';
import 'package:alex4_db/model/note.dart';
import 'package:alex4_db/util/date_time_manager.dart';
import 'package:alex4_db/util/extension/context_extension.dart';
import 'package:flutter/material.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({super.key});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(hintText: 'Title'),
            validator: (value) => value!.isEmpty ? 'Title is required' : null,
          ),
          TextFormField(
            validator: (value) => value!.isEmpty ? 'Content is required' : null,
            controller: _contentController,
            decoration: InputDecoration(hintText: 'Note'),
          ),

          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Note newNote = Note(
                  title: _titleController.text,
                  content: _contentController.text,
                  createdAt: DateTimeManager.currentDateTime(),
                );
                saveNote(newNote);
              }
            },
            child: Text('Add Note'),
          ),
        ],
      ),
    );
  }

  void saveNote(Note newNote) {
    Crud.instance.insert(newNote);
    _titleController.clear();
    _contentController.clear();
    context.showSnackBar('Note saved successfully!');
  }
}
