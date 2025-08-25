// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alex4_db/main.dart';
import 'package:alex4_db/alex_app.dart';
import 'package:alex4_db/home.dart';
import 'package:alex4_db/search/widgets/search_bar.dart';
import 'package:alex4_db/widgets/note_form.dart';
import 'package:alex4_db/widgets/note_list.dart';

void main() {
  testWidgets('Notes app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AlexApp());

    // Verify that our app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Verify that the home page loads
    expect(find.byType(MyHomePage), findsOneWidget);
    
    // Verify that the search bar is present
    expect(find.byType(SearchBarWidget), findsOneWidget);
    
    // Verify that the note form is present
    expect(find.byType(NoteForm), findsOneWidget);
    
    // Verify that the note list is present
    expect(find.byType(NoteList), findsOneWidget);
  });
}
