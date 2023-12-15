// import 'package:path/path.dart';
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'notes.dart';
// import 'dart:io' as io;
// import 'package:path_provider/path_provider.dart';

// class DBHelper {
//   static Database? _database;

//   Future<Database?> get db async {
//     if (_database != null) {
//       return _database;
//     } else {
//       _database = await initDatabase();
//       return _database;
//     }
//   }

//   initDatabase() async {
//     io.Directory documentDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentDirectory.path, 'notes.db');
//     var db = await openDatabase(path, version: 1, onCreate: _onCreate);
//     return db;
//   }

//   _onCreate(Database db, int version) async {
//     await db.execute(
//       "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, time TEXT, date TEXT, isCompleted INTEGER DEFAULT 0)",
//     );
//   }

//   Future<NotesModel> insert(NotesModel notesModel) async {
//     var dbclient = await db;
//     await dbclient!.insert('notes', notesModel.toMap());
//     return notesModel;
//   }

//   Future<List<NotesModel>> getNotesList() async {
//     var dbclient = await db;
//     final List<Map<String, Object?>> queryResult =
//         await dbclient!.query('notes');
//     return queryResult.map((e) => NotesModel.fromMap(e)).toList();
//   }

//   Future<int> delete(int? id) async {
//     var dbclient = await db;
//     return await dbclient!.delete('notes', where: 'id=?', whereArgs: [id]);
//   }

//   Future<int> update(NotesModel notesModel) async {
//     var dbclient = await db;
//     return await dbclient!.update('notes', notesModel.toMap(),
//         where: "id=?", whereArgs: [notesModel.id]);
//   }
// }

// import 'package:path/path.dart';
// import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'notes.dart';
// import 'dart:io' as io;
// import 'package:path_provider/path_provider.dart';

// class DBHelper {
//   static Database? _database;

//   Future<Database?> get db async {
//     if (_database != null) {
//       return _database;
//     } else {
//       _database = await initDatabase();
//       return _database;
//     }
//   }

//   initDatabase() async {
//     io.Directory documentDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentDirectory.path, 'notes.db');
//     var db = await openDatabase(path, version: 1, onCreate: _onCreate);
//     return db;
//   }

//   _onCreate(Database db, int version) async {
//     await db.execute(
//       "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, time TEXT, date TEXT, isCompleted INTEGER DEFAULT 0)",
//     );

//     // Add table for completed tasks
//     await db.execute(
//       "CREATE TABLE completed_tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, time TEXT, date TEXT)",
//     );
//   }

//   Future<NotesModel> insert(NotesModel notesModel) async {
//     var dbclient = await db;
//     await dbclient!.insert('notes', notesModel.toMap());
//     return notesModel;
//   }

//   Future<List<NotesModel>> getNotesList() async {
//     var dbclient = await db;
//     final List<Map<String, Object?>> queryResult =
//         await dbclient!.query('notes');
//     return queryResult.map((e) => NotesModel.fromMap(e)).toList();
//   }

//   Future<int> delete(int? id) async {
//     var dbclient = await db;
//     return await dbclient!.delete('notes', where: 'id=?', whereArgs: [id]);
//   }

//   Future<int> update(NotesModel notesModel) async {
//     var dbclient = await db;
//     return await dbclient!.update('notes', notesModel.toMap(),
//         where: "id=?", whereArgs: [notesModel.id]);
//   }

//   // Insert a completed task
//   Future<void> insertCompletedTask(NotesModel task) async {
//     var dbclient = await db;
//     await dbclient!.insert('completed_tasks', task.toMap());
//   }

//   // Get a list of completed tasks
//   Future<List<NotesModel>> getCompletedTasksList() async {
//     var dbclient = await db;
//     final List<Map<String, Object?>> queryResult =
//         await dbclient!.query('completed_tasks');
//     return queryResult.map((e) => NotesModel.fromMap(e)).toList();
//   }

//   // Delete a completed task
//   Future<int> deleteCompletedTask(int taskId) async {
//     var dbclient = await db;
//     return await dbclient!
//         .delete('completed_tasks', where: 'id = ?', whereArgs: [taskId]);
//   }
// }

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'notes.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database? _database;

  Future<Database?> get db async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDatabase();
      return _database;
    }
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, time TEXT, date TEXT, isCompleted INTEGER DEFAULT 0)",
    );
  }

  Future<NotesModel> insert(NotesModel notesModel) async {
    var dbclient = await db;
    await dbclient!.insert('notes', notesModel.toMap());
    return notesModel;
  }

  Future<List<NotesModel>> getNotesList() async {
    var dbclient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbclient!.query('notes');
    return queryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  Future<int> delete(int? id) async {
    var dbclient = await db;
    return await dbclient!.delete('notes', where: 'id=?', whereArgs: [id]);
  }

  Future<List<NotesModel>> getCompletedTasksList() async {
    var dbclient = await db;
    final List<Map<String, Object?>> queryResult = await dbclient!
        .query('notes', where: 'isCompleted = ?', whereArgs: [1]);
    return queryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  Future<int> update(NotesModel notesModel) async {
    var dbclient = await db;
    return await dbclient!.update('notes', notesModel.toMap(),
        where: "id=?", whereArgs: [notesModel.id]);
  }
}
