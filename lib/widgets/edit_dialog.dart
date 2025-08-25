import 'package:alex4_db/db/crud.dart';
import 'package:alex4_db/model/note.dart';
import 'package:alex4_db/util/date_time_manager.dart';
import 'package:alex4_db/util/extension/context_extension.dart';
import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({super.key, required this.note});

  final Note note;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.note.title;
    _contentController.text = widget.note.content;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Note'),
      content: Form(
        key: _editFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Title'),
              validator: (value) => value!.isEmpty ? 'Title is required' : null,
            ),
            TextFormField(
              validator: (value) =>
              value!.isEmpty ? 'Content is required' : null,
              controller: _contentController,
              decoration: InputDecoration(hintText: 'Note'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(onPressed: () {
          if (_editFormKey.currentState!.validate()) {
            Note updatedNote = widget.note.copyWith(
                title: _titleController.text, content: _contentController.text, updatedAt: DateTimeManager.currentDateTime());
            updateNote(updatedNote);
          }
        }, child: Text('Update')),
      ],
    );
  }

  void updateNote(Note updatedNote) {
    Crud.instance.update(updatedNote);
    context.showSnackBar('Note updated successfully!');
    Navigator.pop(context);
  }
}
