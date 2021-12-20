import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:places/src/core/constants/app_constants.dart';
import 'package:places/src/model/user_model.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  Database? _db;

  DbProvider() {
    _init();
  }

  Future<void> _init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(dir.path, DB_NAME);
    _db = await openDatabase(dbPath, version: 2,
        onCreate: (Database newDb, int version) {
      Batch batch = newDb.batch();
      batch.execute("""
            CREATE TABLE $USER_TABLE (
              id TEXT PRIMARY KEY,
              isAdmin INTEGER,
              name TEXT,
              email TEXT,
              phone INTEGER,
              registrationDate TEXT
            )
        """);
      for (int i = 1; i < version; i++) {
        for (var value in getMigrations()[i - 1]) {
          batch.execute(value);
        }
      }

      batch.commit();
    }, onUpgrade: (Database newDb, int oldVersion, int newVersion) {
      Batch batch = newDb.batch();
      for (int i = oldVersion; i < newVersion; i++) {
        for (var value in getMigrations()[i - 1]) {
          batch.execute(value);
        }
      }
      batch.commit();
    });
  }

  List<List<String>> getMigrations() {
    return [
      [
        "ALTER TABLE $USER_TABLE  ADD coverPic TEXT",
        "ALTER TABLE $USER_TABLE  ADD profilePic TEXT",
        "ALTER TABLE $USER_TABLE  ADD pushToken TEXT",
      ],
    ];
  }

  Future<int> insertUser(UserModel user) async {
    if (_db == null) await _init();
    await _db!.delete(USER_TABLE);
    return _db!.insert(USER_TABLE, user.toDb());
  }

  Future<UserModel?> getUser() async {
    if (_db == null) await _init();
    final data = await _db!.query(USER_TABLE);
    if (data.length != 1) return null;
    return UserModel.fromDb(data.first);
  }

  Future<void> clear() async {
    if (_db == null) await _init();
    _db!.delete(USER_TABLE);
  }
}
