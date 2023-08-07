import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student/functions/functions.dart';
import 'package:student/model/students.dart';
import 'package:student/Screens/profile_student_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Students'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _searchStudents,
              decoration: const InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _buildStudentList(),
          ),
        ],
      ),
    );
  }

  void _searchStudents(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  Widget _buildStudentList() {
    return ValueListenableBuilder<List<Students>>(
      builder: (context, studentList, child) {
        final filteredList = studentList.where((student) {
          return student.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
        }).toList();

        if (_searchQuery.isEmpty) {
          return Container(); // Show an empty container when the search query is empty
        } else if (filteredList.isEmpty) {
          return const Center(child: Text('No students found'));
        } else {
          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final student = filteredList[index];
              return ListTile(
                leading: SizedBox.square(
                  dimension: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: student.image.isEmpty
                        ? Image.network(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                        : Image.file(
                            File(student.image),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                title: Text(student.name),
                onTap: () {
                  // Handle tapping on the student in the search results.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileStudentScreen(student: student),
                    ),
                  );
                },
              );
            },
          );
        }
      },
      valueListenable: studentListNotifier,
    );
  }
}
