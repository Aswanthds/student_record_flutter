import 'package:flutter/material.dart';
//import 'package:student/functions/functions.dart';
import 'package:student/model/students.dart';

class SearchPageScreen extends StatefulWidget {
  const SearchPageScreen({Key? key}) : super(key: key);

  @override
  State<SearchPageScreen> createState() => _SearchPageScreenState();
}

class _SearchPageScreenState extends State<SearchPageScreen> {
  final _searchController = TextEditingController();
  List<Students>? students;

  @override
  void initState() {
    super.initState();
    getStudents();
  }

  void getStudents() async {
    setState(() {});
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        labelText: 'Search',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            students = students!
                .where((student) => student.name.toLowerCase().contains(value))
                .toList();
          } else {
            students = null;
          }
        });
      },
    );
  }

  Widget _buildStudentList() {
    if (students == null) {
      return const Center(child: Text('No students found'));
    } else {
      return ListView.builder(
        itemCount: students!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(students![index].name),
            subtitle: Text(students![index].domain),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            _buildStudentList(),
          ],
        ),
      ),
    );
  }
}
