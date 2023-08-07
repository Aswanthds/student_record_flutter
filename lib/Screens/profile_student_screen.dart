import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student/Screens/edit_screen.dart';
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
              deleteStudent(widget.student.id!)
                  .then((value) => Navigator.of(context).pop());
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
                        ? Image.network(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
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
}
