import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SavedPerson {
  String id;

  SavedPerson(this.id);

  Map<String, dynamic> toMap() => {'id': id};

  SavedPerson.fromMap(Map<String, dynamic> map) {
    id = map['id'];
  }
}

class SavedPeopleModel with ChangeNotifier {
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'people.db'),
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE people (
          id STRING UNIQUE
        )
        ''');
    }, version: 1);
  }

  Future<List> getAllPeople() async {
    final db = await database;
    var res = await db.query("people");

    if (res.length == 0)
      return null;
    else {
      return res;
    }
  }

  insertPeople(SavedPerson person) async {
    final db = await database;
    try {
      await db.insert("people", person.toMap());
    } catch (error) {
      return error;
    }

    notifyListeners();
  }

  deletePeopleId(String id) async {
    final db = await database;
    await db.delete(
      "people",
      where: 'id = ?',
      whereArgs: [id],
    );

    notifyListeners();
  }
}
