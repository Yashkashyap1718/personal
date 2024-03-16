// ignore_for_file: depend_on_referenced_packages, file_names

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:money_bank/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  Future<Database> initDatabase() async {
    String path = await getDatabasesPath();

    return await openDatabase(
      join(path, 'charnasparsh.db'), // Update with your desired database name
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          uid TEXT,
          username TEXT,
          phoneNumber TEXT,
          email TEXT,
          studentId TEXT,
          collegeName TEXT,
          cityName TEXT,
          profilePic TEXT
        )
      ''');

        await db.execute('''
        CREATE TABLE userstatus(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          videos INTEGER,
          quiz INTEGER,
          mocktest INTEGER,
          roadathon INTEGER,
          userId TEXT,
          username TEXT,
          quizTime TEXT,
          FOREIGN KEY(userId) REFERENCES users(uid)
        )
      ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 3) {
          // Check if the phoneNumber column does not exist before attempting to add it

          List<Map<String, dynamic>> columns =
              await db.rawQuery("PRAGMA table_info(userstatus)");

          bool phoneNumberColumnExists = columns.any((column) =>
              column['name'].toString().toLowerCase() == 'quizTime');

          if (!phoneNumberColumnExists) {
            await db.execute('ALTER TABLE userstatus ADD COLUMN quizTime TEXT');
          }
        }
      },
    );
  }

  Future<bool> insertUser(UserModel user) async {
    try {
      final db = await initDatabase();
      await db.insert('users', user.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("-------------------- error ------------ $e");
      }
      return false;
    }
  }

  Future<UserModel> getUsers() async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('users');

    if (maps.isNotEmpty) {
      return maps.map((e) => UserModel.fromJson(e)).first;
    } else {
      return UserModel();
    }
  }

  Future<void> deleteUser(int id) async {
    final db = await initDatabase();
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Future<bool> insertUserStatus(UserStatus userStatus) async {
  //   try {
  //     final db = await initDatabase();
  //     await db.delete('userstatus');

  //     await db.insert('userstatus', userStatus.toMap(),
  //         conflictAlgorithm: ConflictAlgorithm.replace);

  //     return true;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("user status error - ===================================== - $e");
  //     }
  //     return false;
  //   }
  // }

  // Future<UserStatus> getUserStatus() async {
  //   final db = await initDatabase();
  //   final List<Map<String, dynamic>> maps = await db.query('userstatus');

  //   if (maps.isNotEmpty) {
  //     return maps.map((e) => UserStatus.fromMap(e)).first;
  //   } else {
  //     return UserStatus();
  //   }
  // }

  Future<void> deleteUserStatus(int id) async {
    final db = await initDatabase();
    await db.delete('userstatus', where: 'id = ?', whereArgs: [id]);
  }

  // Future<void> updateStatus(UserStatus userStatus, [status]) async {
  //   final db = await initDatabase();
  //   await db.update(
  //     'userstatus',
  //     userStatus.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [userStatus.id],
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  Future<void> cleanUserTable() async {
    final db = await initDatabase();

    await db.delete("users");
    await db.delete('userstatus');
  }
}
