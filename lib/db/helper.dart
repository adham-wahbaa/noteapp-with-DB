import 'dart:async';
import 'dart:io';

import 'package:alex4_db/db/db_constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._(); //private named constructor
  static final DbHelper instance = DbHelper._();

  //get db path
  Future<String> _getDbPath() async {
    String path = await getDatabasesPath(); //sqflite package
    return join(path, DbConstants.dbName);
  }

  // Future<String> getExternalDbPath() async {
  //   Directory dir = await getApplicationDocumentsDirectory();
  //   return join(dir.path, DbConstants.dbName);
  // }
  Future<Database> getDbInstance() async {
    String path = await _getDbPath();
    return await openDatabase(
      path,
      version: DbConstants.dbVersion,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onOpen: _onOpen,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
      singleInstance: true,
    );
  }

  FutureOr<void> _onConfigure(Database db) {
    print('Configuring database...');
  }

  FutureOr<void> _onCreate(Database db, int version) {
    print('Creating database tables...');
    try {
      String sql =
          'create table ${DbConstants.tableName} (${DbConstants.columnId} integer primary key autoincrement, ${DbConstants.columnTitle} text not null, ${DbConstants.columnContent} text not null, ${DbConstants.columnCreatedAt} text not null, ${DbConstants.columnUpdatedAt} text)';
      db.execute(sql);
    } on DatabaseException catch (e) {
      print('DatabaseException $e');
    }
  }

  FutureOr<void> _onOpen(Database db) {
    print('Opening database...');
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {
    print('Upgrading database from version $oldVersion to $newVersion...');
  }

  FutureOr<void> _onDowngrade(Database db, int oldVersion, int newVersion) {
    print('Downgrading database from version $oldVersion to $newVersion...');
  }
}
