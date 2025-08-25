class DbConstants{
  DbConstants._();
  static const String dbName = 'app_database.db';
  static const int dbVersion = 1;
  static const String tableName = 'notes';
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnContent = 'content';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
}