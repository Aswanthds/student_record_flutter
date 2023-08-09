import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student/Screens/edit_student_screen.dart';
import 'package:student/Screens/home_screen.dart';
import 'package:student/functions/functions.dart';
import 'package:student/model/students.dart';

class ProfileStudentScreen extends StatefulWidget {
  final Students student;

  const ProfileStudentScreen({super.key, required this.student});

  @override
  State<ProfileStudentScreen> createState() => _ProfileStudentScreenState();
}

class _ProfileStudentScreenState extends State<ProfileStudentScreen> {
  bool isLoading = false;
  List<Students>? list;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Are you Sure ?"),
                  content: const Text("Once you delete ,u cant recover it"),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          _deleteStudent(widget.student, context).then(
                              (value) => Navigator.of(context)
                                  .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()),
                                      (route) => false));
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Delete"))
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () async {
              if (isLoading) return;
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditStudentScreen(
                  student: widget.student,
                ),
              ));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox.square(
                  dimension: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: widget.student.image.isEmpty
                        ? Image.asset(
                            defaultImageUrl,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(widget.student.image),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Text(
                  widget.student.name,
                  style: const TextStyle(fontSize: 40),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Age: ${widget.student.age} yrs",
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  "Email: ${widget.student.email} ",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Domain :  ${widget.student.domain}",
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
      //
    );
  }

  Future<void> _deleteStudent(Students student, BuildContext ctx) async {
    try {
       deleteStudent(student.id!);
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          margin: EdgeInsets.all(5),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          content: Text("Removed Sucesfully")));
    } catch (e) {
      log("Exception filed :${e.toString()}");
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          margin: EdgeInsets.all(5),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          content: Text("Error Occured")));
    }
  }
}
