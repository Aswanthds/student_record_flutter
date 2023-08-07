import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student/functions/functions.dart';
import 'package:student/model/students.dart';

class EditStudentScreen extends StatefulWidget {
  final Students? student;

  const EditStudentScreen({super.key, this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _ageController = TextEditingController();

  final _emailController = TextEditingController();

  final _domainController = TextEditingController();

  final _imageController = TextEditingController();

  XFile? _imageFile;

  // Variable to store the selected image file
  Future<void> _getImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = XFile(pickedFile.path);
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = XFile(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _domainController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Widget get saveButton => OutlinedButton(
        onPressed: () {
          addStudents(widget.student!);
        },
        child: const Text("Save"),
      );

  bool isEmailValid(String email) {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    return emailRegExp.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      _nameController.text = widget.student!.name;
      _ageController.text = widget.student!.age.toString();
      _emailController.text = widget.student!.email;
      _domainController.text = widget.student!.domain;
      _imageController.text = widget.student!.image;
    }
  }

  void _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      final newStudent = Students(
        id: widget.student?.id ??
            0, // Use the original student's id if available
        name: _nameController.text.isEmpty
            ? widget.student?.name ?? ''
            : _nameController.text,
        age: _ageController.text.isEmpty
            ? widget.student?.age ?? 0
            : int.tryParse(_ageController.text) ?? 0,
        email: _emailController.text.isEmpty
            ? widget.student?.email ?? ''
            : _emailController.text,
        domain: _domainController.text.isEmpty
            ? widget.student?.domain ?? ''
            : _domainController.text,
        image: (_imageFile == null && widget.student != null)
            ? widget.student!.image
            : _imageFile!.path,
      );

      updateStudent(
        newStudent.id!,
        newStudent.name,
        newStudent.email,
        newStudent.domain,
        newStudent.image,
        newStudent.age!,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Student",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Name', hintText: ''),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an age';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!isEmailValid(value)) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _domainController,
                  decoration: const InputDecoration(labelText: 'Domain'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your domain';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: _getImageFromCamera,
                        icon: const Icon(
                          Icons.camera,
                          color: Colors.black,
                        ),
                        label: const Text(
                          'Camera',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: _getImageFromGallery,
                        icon: const Icon(
                          Icons.upload,
                          color: Colors.black,
                        ),
                        label: const Text(
                          'Upload',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      _saveStudent();
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
