import 'package:alex4_db/db/db_constants.dart';
import 'package:alex4_db/db/helper.dart';
import 'package:alex4_db/model/note.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Crud {
  Crud._();

  static final Crud instance = Crud._();
  ValueNotifier<List<Note>> noteNotifier = ValueNotifier([]);

  //insert new record
  Future<void> insert(Note note) async {
    Database db = await DbHelper.instance.getDbInstance();
    int row = await db.insert(
      DbConstants.tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (row > 0) {
      selectAll();
    }
  }

  //get all records
  Future<List<Note>> selectAll() async {
    Database db = await DbHelper.instance.getDbInstance();
    List<Map<String, dynamic>> result = await db.query(
      DbConstants.tableName,
      distinct: true,
      orderBy: '${DbConstants.columnCreatedAt} DESC',
    );
    List<Note> notes = result.map((e) => Note.fromMap(e)).toList();
    noteNotifier.value = notes;
    return notes;
  }

  //delete record by id
  Future<void> delete(int id) async {
    Database db = await DbHelper.instance.getDbInstance();
    int row = await db.delete(
      DbConstants.tableName,
      where: '${DbConstants.columnId}=?',
      whereArgs: [id],
    );
    if (row > 0) {
      selectAll();
    }
  }

  //update record by id
  Future<void> update(Note note) async {
    Database db = await DbHelper.instance.getDbInstance();
    int row = await db.update(
      DbConstants.tableName,
      note.toMap(),
      where: '${DbConstants.columnId}=?',
      whereArgs: [note.id],
    );
    if (row > 0) {
      selectAll();
    }
  }
}
