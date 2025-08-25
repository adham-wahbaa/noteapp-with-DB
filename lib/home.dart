import 'package:alex4_db/widgets/note_form.dart';
import 'package:alex4_db/widgets/note_list.dart';
import 'package:alex4_db/search/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SearchBarWidget(),
                NoteForm(),
                NoteList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
