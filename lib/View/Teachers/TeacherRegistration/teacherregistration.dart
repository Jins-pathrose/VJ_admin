import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vj_admin/Model/Teacher/teacherservice.dart';
import 'package:vj_admin/View/Widgets/teacher_registrationwidget.dart';

class TeacherRegistration extends StatefulWidget {
  const TeacherRegistration({super.key});

  @override
  State<TeacherRegistration> createState() => _TeacherRegistrationState();
}

class _TeacherRegistrationState extends State<TeacherRegistration> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSubject;
  List<String> _categories = [];
  List<String> _subjects = [];
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchSubjects();
  }

  Future<void> _fetchCategories() async {
    List<String> categories = await _teacherService.fetchCategories(context);
    setState(() => _categories = categories);
  }

  Future<void> _fetchSubjects() async {
    List<String> subjects = await _teacherService.fetchSubjects(context);
    setState(() => _subjects = subjects);
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _handleRegistration() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _numberController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _teacherService.registerTeacher(
        context: context,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        number: _numberController.text.trim(),
        category: _selectedCategory!,
        subject: _selectedSubject!,
        image: _image,
      );

      _nameController.clear();
      _emailController.clear();
      _numberController.clear();
      setState(() {
        _image = null;
        _selectedCategory = null;
        _selectedSubject = null;
      });
    } catch (e) {
      // Error handling is done in TeacherService
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Teacher Registration",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(Icons.camera_alt,
                            size: 40, color: Colors.black)
                        : null,
                  ),
                ),
                const SizedBox(height: 15),
                BulildTextField(controller:  _nameController,hintText:  "Full Name",icon:  Icons.person),
                BulildTextField(controller:  _emailController,hintText:  "Email",icon:  Icons.email),
                BulildTextField(controller:  _numberController,hintText:  "Phone Number",icon:  Icons.phone),
                DropDown(
                  hint: "Select Class Category",
                  items: _categories,
                  selectedValue: _selectedCategory,
                  onChanged: (value) {
                    setState(() => _selectedCategory = value);
                  },
                ),
                TextButton(
                  onPressed: () =>
                      _teacherService.addNewCategory(context, _fetchCategories),
                  child: const Text("Add New Category"),
                ),
                DropDown(
                  hint: "Select Subject",
                  items: _subjects,
                  selectedValue: _selectedSubject,
                  onChanged: (value) {
                    setState(() => _selectedSubject = value);
                  },
                ),
                TextButton(
                  onPressed: () =>
                      _teacherService.addNewSubject(context, _fetchSubjects),
                  child: const Text("Add New Subject"),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Register",
                            style:
                                TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
