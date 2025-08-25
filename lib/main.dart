import 'package:alex4_db/alex_app.dart';
import 'package:alex4_db/db/helper.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DbHelper.instance.getDbInstance();
  runApp(const AlexApp());
}
