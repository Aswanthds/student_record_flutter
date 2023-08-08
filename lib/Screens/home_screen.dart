import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student/Screens/add_student_screen.dart';
import 'package:student/Screens/edit_screen.dart';
import 'package:student/Screens/profile_student_screen.dart';
import 'package:student/Screens/search.dart';
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
    getAllStudent();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Student Record'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ));
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: ValueListenableBuilder(
        builder: (BuildContext context, studentList, Widget? child) {
          return RefreshIndicator(
            onRefresh: getAllStudent,
            child: ListView.builder(
              itemCount: studentList.length,
              itemBuilder: (context, index) {
                final student = studentList[index];
                return SizedBox(
                  height: 80,
                  child: ListWidget(
                    student: student,
                  ),
                );
              },
            ),
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
  final String defaultImageUrl = 'assets/dummy.webp';

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
                  ? Image.asset(defaultImageUrl)
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Are you Sure ?"),
                      content: Text("Once you delete ,u cant recover it"),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              _deleteStudent(student, context)
                                  .then((value) => Navigator.of(context).pop());
                            },
                            icon: Icon(Icons.delete),
                            label: Text("Delete"))
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteStudent(Students student, BuildContext ctx) async {
    try {
      await deleteStudent(student.id!);
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          margin: EdgeInsets.all(5),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          content: Text("Removed Sucesfully")));
    } catch (e) {
      print("Exception filed :${e.toString()}");
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          margin: EdgeInsets.all(5),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Text("Error Occured")));
    }
  }
}
