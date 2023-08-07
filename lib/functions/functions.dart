// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student/model/students.dart';

ValueNotifier<List<Students>> studentListNotifier = ValueNotifier([]);
late Database _db;

Future<void> initializeDatabase() async {
  _db = await openDatabase(
    'student.db',
    version: 1,
    onCreate: (db, version) {
      db.execute('''
    CREATE TABLE $studentsTable (
      ${StudentsFields.id} INTEGER PRIMARY KEY AUTOINCREMENT ,
      ${StudentsFields.name} TEXT,
      ${StudentsFields.age} INTEGER NOT NULL,
      ${StudentsFields.email} TEXT,
      ${StudentsFields.domain} TEXT,
      ${StudentsFields.image} TEXT
    )
  ''');
    },
  );
}

Future<void> addStudents(Students student) async {
  try {
    await _db.rawInsert(
        'INSERT INTO $studentsTable (${StudentsFields.name},${StudentsFields.age},${StudentsFields.email},${StudentsFields.domain},${StudentsFields.image}) VALUES (?,?,?,?,?)',
        [
          student.name,
          student.age,
          student.email,
          student.domain,
          student.image
        ]);
    studentListNotifier.value.add(student);
    studentListNotifier.notifyListeners();
  } catch (e) {
    print("Exception filed :${e.toString()}");
  }
}

Future<void> getAllStudent() async {
  final result = await _db.rawQuery('SELECT * FROM $studentsTable');
  List<Students> studentsList =
      result.map((row) => Students.fromMap(row)).toList();
  studentListNotifier.value = studentsList;
  studentListNotifier.notifyListeners();
}

Future<void> deleteStudent(int id) async {
  try {
    await _db.rawDelete('DELETE FROM $studentsTable WHERE id = ?', [id]);
    studentListNotifier.value.remove(StudentsFields.id);
    getAllStudent();
  } catch (e) {
    print("Exception filed :${e.toString()}");
  }
}

Future<void> updateStudent(int id, String name, String email, String domain,
    String image, int age) async {
  await _db.rawUpdate(
      'UPDATE $studentsTable SET ${StudentsFields.name} = ?, ${StudentsFields.age} = ? , ${StudentsFields.email} = ?, ${StudentsFields.domain} =?, ${StudentsFields.image} =? WHERE ${StudentsFields.id} = ?',
      [
        name,
        age,
        email,
        domain,
        image,
        id,
      ]);
  Students? updatedStudent = studentListNotifier.value.firstWhere(
    (student) => student.id == id,
  );
  if (updatedStudent != null) {
    // Update the student properties in the list
    updatedStudent.name = name;
    updatedStudent.age = age;
    updatedStudent.email = email;
    updatedStudent.domain = domain;
    updatedStudent.image = image;

    studentListNotifier.notifyListeners();
  }
  studentListNotifier.notifyListeners();
  getAllStudent();
}
