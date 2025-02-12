
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:vj_admin/Model/Teacher/teacherservice.dart';
// import 'package:vj_admin/View/Widgets/teacheredit_dropdown.dart';

// class TeacherEdit extends StatefulWidget {
//   final String teacherId;
//   final Map<String, dynamic> teacherData;

//   const TeacherEdit({
//     Key? key,
//     required this.teacherId,
//     required this.teacherData,
//   }) : super(key: key);

//   @override
//   State<TeacherEdit> createState() => _TeacherEditState();
// }

// class _TeacherEditState extends State<TeacherEdit> {
//   File? _image;
//   final picker = ImagePicker();
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _numberController;
//   String? _selectedCategory;
//   String? _selectedSubject;
//   List<String> _categories = [];
//   List<String> _subjects = [];
//   final TeacherService _teacherService = TeacherService();
//   bool _isLoading = false;
//   String? _currentImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.teacherData['name']);
//     _emailController = TextEditingController(text: widget.teacherData['email']);
//     _numberController = TextEditingController(text: widget.teacherData['number']);
//     _selectedCategory = widget.teacherData['classCategory'];
//     _selectedSubject = widget.teacherData['subject'];
//     _currentImageUrl = widget.teacherData['image'];
//     _fetchCategories();
//     _fetchSubjects();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _numberController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchCategories() async {
//     List<String> categories = await _teacherService.fetchCategories(context);
//     setState(() => _categories = categories);
//   }

//   Future<void> _fetchSubjects() async {
//     List<String> subjects = await _teacherService.fetchSubjects(context);
//     setState(() => _subjects = subjects);
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() => _image = File(pickedFile.path));
//     }
//   }

//   Future<void> _updateTeacher() async {
//     if (_nameController.text.isEmpty ||
//         _emailController.text.isEmpty ||
//         _numberController.text.isEmpty ||
//         _selectedCategory == null ||
//         _selectedSubject == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all required fields')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       String? imageUrl = _currentImageUrl;
//       if (_image != null) {
//         imageUrl = await _teacherService.uploadToCloudinary(_image!);
//       }

//       await FirebaseFirestore.instance
//           .collection('teachers_registration')
//           .doc(widget.teacherId)
//           .update({
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'number': _numberController.text.trim(),
//         'subject': _selectedSubject,
//         'classCategory': _selectedCategory,
//         'image': imageUrl,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Teacher details updated successfully!')),
//       );
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating teacher: ${e.toString()}')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Edit Teacher",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.black,
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: _pickImage,
//                   child: Container(
//                     width: 120,
//                     height: 120,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.grey[200],
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: ClipOval(
//                       child: _image != null
//                           ? Image.file(_image!, fit: BoxFit.cover)
//                           : _currentImageUrl != null && _currentImageUrl!.isNotEmpty
//                               ? Image.network(_currentImageUrl!, fit: BoxFit.cover)
//                               : const Icon(Icons.camera_alt,
//                                   size: 40, color: Colors.black),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         TeacherEditTextBox(controller:  _nameController,label: "Full Name",icon: Icons.person),
//                         TeacherEditTextBox(controller:  _emailController,label:  "Email",icon:  Icons.email),
//                         TeacherEditTextBox(
//                            controller: _numberController,label:  "Phone Number",icon:  Icons.phone),
//                         const SizedBox(height: 16),
//                         TeacherEditDropdown(
//                           hint: "Select Class Category",
//                          items: _categories,
//                           selectedValue: _selectedCategory,
//                          onChanged: (value) => setState(() => _selectedCategory = value),
//                         ),
//                         const SizedBox(height: 16),
//                         TeacherEditDropdown(
//                          hint:  "Select Subject",
//                          items: _subjects,
//                           selectedValue: _selectedSubject,
//                          onChanged:  (value) => setState(() => _selectedSubject = value),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: _isLoading ? null : _updateTeacher,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.amber,
//                       foregroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       elevation: 4,
//                     ),
//                     child: _isLoading
//                         ? const CircularProgressIndicator()
//                         : const Text(
//                             "Update",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (_isLoading)
//             Container(
//               color: Colors.black.withOpacity(0.5),
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vj_admin/Controller/TeacherEdit/bloc/teacheredit_bloc.dart';
import 'package:vj_admin/Controller/TeacherEdit/bloc/teacheredit_event.dart';
import 'package:vj_admin/Controller/TeacherEdit/bloc/teacheredit_state.dart';
import 'package:vj_admin/Model/Teacher/teacherservice.dart';
import 'package:vj_admin/View/Widgets/teacheredit_dropdown.dart';
// Import your bloc file

class TeacherEdit extends StatefulWidget {
  final String teacherId;
  final Map<String, dynamic> teacherData;

  const TeacherEdit({
    Key? key,
    required this.teacherId,
    required this.teacherData,
  }) : super(key: key);

  @override
  State<TeacherEdit> createState() => _TeacherEditState();
}

class _TeacherEditState extends State<TeacherEdit> {
  File? _image;
  final picker = ImagePicker();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _numberController;
  String? _selectedCategory;
  String? _selectedSubject;
  List<String> _categories = [];
  List<String> _subjects = [];
  String? _currentImageUrl;
  late TeacherEditBloc _teacherEditBloc;

  @override
  void initState() {
    super.initState();
    _teacherEditBloc = TeacherEditBloc(teacherService: TeacherService());
    _nameController = TextEditingController(text: widget.teacherData['name']);
    _emailController = TextEditingController(text: widget.teacherData['email']);
    _numberController = TextEditingController(text: widget.teacherData['number']);
    _selectedCategory = widget.teacherData['classCategory'];
    _selectedSubject = widget.teacherData['subject'];
    _currentImageUrl = widget.teacherData['image'];
    
    _teacherEditBloc.add(FetchCategories());
    _teacherEditBloc.add(FetchSubjects());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    _teacherEditBloc.close();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _updateTeacher() {
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

    _teacherEditBloc.add(
      UpdateTeacherDetails(
        teacherId: widget.teacherId,
        name: _nameController.text,
        email: _emailController.text,
        number: _numberController.text,
        category: _selectedCategory!,
        subject: _selectedSubject!,
        newImage: _image,
        currentImageUrl: _currentImageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _teacherEditBloc,
      child: BlocListener<TeacherEditBloc, TeacherEditState>(
        listener: (context, state) {
          if (state is TeacherEditSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Teacher details updated successfully!')),
            );
            Navigator.pop(context);
          } else if (state is TeacherEditFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: BlocBuilder<TeacherEditBloc, TeacherEditState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Edit Teacher",
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
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: _image != null
                                  ? Image.file(_image!, fit: BoxFit.cover)
                                  : _currentImageUrl != null && _currentImageUrl!.isNotEmpty
                                      ? Image.network(_currentImageUrl!, fit: BoxFit.cover)
                                      : const Icon(Icons.camera_alt,
                                          size: 40, color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                TeacherEditTextBox(
                                  controller: _nameController,
                                  label: "Full Name",
                                  icon: Icons.person,
                                ),
                                TeacherEditTextBox(
                                  controller: _emailController,
                                  label: "Email",
                                  icon: Icons.email,
                                ),
                                TeacherEditTextBox(
                                  controller: _numberController,
                                  label: "Phone Number",
                                  icon: Icons.phone,
                                ),
                                const SizedBox(height: 16),
                                TeacherEditDropdown(
                                  hint: "Select Class Category",
                                  items: _categories,
                                  selectedValue: _selectedCategory,
                                  onChanged: (value) =>
                                      setState(() => _selectedCategory = value),
                                ),
                                const SizedBox(height: 16),
                                TeacherEditDropdown(
                                  hint: "Select Subject",
                                  items: _subjects,
                                  selectedValue: _selectedSubject,
                                  onChanged: (value) =>
                                      setState(() => _selectedSubject = value),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: state is TeacherEditLoading ? null : _updateTeacher,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                            child: state is TeacherEditLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "Update",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state is TeacherEditLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}