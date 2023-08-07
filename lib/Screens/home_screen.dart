import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student/Screens/add_student_screen.dart';
import 'package:student/Screens/edit_screen.dart';
import 'package:student/Screens/profile_student_screen.dart';

import 'package:student/functions/functions.dart';
import 'package:student/model/students.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<Students>? studentList;
  Students? student;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Record'),
        actions: [
          IconButton(onPressed: getAllStudent, icon: Icon(Icons.refresh))
        ],
      ),
      body: ValueListenableBuilder(
        builder: (BuildContext context, studentList, Widget? child) {
          return ListView.builder(
            itemCount: studentList.length,
            itemBuilder: (context, index) {
              final student = studentList[index];
              return SizedBox(
                height: 80,
                child: ListWidget(student: student),
              );
            },
          );
        },
        valueListenable: studentListNotifier,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudentScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ListWidget extends StatelessWidget {
  const ListWidget({
    super.key,
    required this.student,
  });

  final Students student;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        color: const Color(0xFFEECA00),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileStudentScreen(
                student: student,
              ),
            ));
          },
          leading: SizedBox.square(
            dimension: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: student.image.isEmpty
                  ? Image.network(
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                  : Image.file(
                      File(student.image),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          title: Text(
            student.name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            student.domain,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Wrap(
            spacing: 20,
            direction: Axis.horizontal,
            children: [
              IconButton(
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EditStudentScreen(
                              student: student,
                            )),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                color: Colors.black,
                onPressed: () {
                  deleteStudent(student.id!);
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
