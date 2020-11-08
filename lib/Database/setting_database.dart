// import 'package:flutter/widgets.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class Settings {
//   String missingPeopleScreen;
//   String savedPeopleScreen;

//   Settings({this.missingPeopleScreen, this.savedPeopleScreen});

//   Map<String, dynamic> toMap() => {
//         'missingPeopleScreen': missingPeopleScreen,
//         'savedPeopleScreen': savedPeopleScreen,
//       };
// }

// class PeopleModel with ChangeNotifier {
//   static Database _database;

//   Future<Database> get database async {
//     if (_database != null) return _database;

//     _database = await initDB();
//     return _database;
//   }

//   initDB() async {
//     return await openDatabase(join(await getDatabasesPath(), 'people.db'),
//         onCreate: (db, version) async {
//       await db.execute('''
//         CREATE TABLE people (
//           missingPeopleScreen TEXT,
//           savedPeopleScreen TEXT
//         )
//         ''');
//     }, version: 1);
//   }

//   Future<List> getAllGrades() async {
//     final db = await database;
//     var res = await db.query("people");

//     if (res.length == 0)
//       return null;
//     else {
//       return res;
//     }
//   }

  // insertGrade(Person person) async {
  //   final db = await database;
  //   await db.insert("people", person.toMap());

  //   notifyListeners();
  // }

  // updateGrade(Person person) async {
  //   final db = await database;
  //   await db.update(
  //     "people",
  //     person.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [person.id],
  //   );

  //   notifyListeners();
  // }

  // deleteGradeById(int id) async {
  //   final db = await database;
  //   await db.delete(
  //     "people",
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );

  //   notifyListeners();
  // }

  // Future close() async {
  //   final db = await database;
  //   db.close();
  // }
// }
