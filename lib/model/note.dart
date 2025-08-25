import 'package:alex4_db/db/db_constants.dart';

class Note {
  final int? id;
  final String title;
  final String content;
  final String createdAt;
  final String? updatedAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    DbConstants.columnId: id,
    DbConstants.columnTitle: title,
    DbConstants.columnContent: content,
    DbConstants.columnCreatedAt: createdAt,
    DbConstants.columnUpdatedAt: updatedAt,
  };

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map[DbConstants.columnId] as int?,
      title: map[DbConstants.columnTitle] as String,
      content: map[DbConstants.columnContent] as String,
      createdAt: map[DbConstants.columnCreatedAt] as String,
      updatedAt: map[DbConstants.columnUpdatedAt] as String?,
    );
  }


  Note copyWith({
    int? id,
    String? title,
    String? content,
    String? createdAt,
    String? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
