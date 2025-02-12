
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class EditTeacher extends StatefulWidget {
//   final String teacherId;
//   final Map<String, dynamic> teacherData;

//   const EditTeacher({
//     Key? key,
//     required this.teacherId,
//     required this.teacherData,
//   }) : super(key: key);

//   @override
//   State<EditTeacher> createState() => _EditTeacherState();
// }

// class _EditTeacherState extends State<EditTeacher> {
//   File? _image;
//   final picker = ImagePicker();
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _numberController;
//   late TextEditingController _subjectController;
//   String? currentImageUrl;
  
//   // Add class category
//   String? _selectedCategory;
//   final List<String> _categories = [
//     'Young Minds (5th to 7th)',
//     'Achievers (8th to 10th)',
//     'Vibrant Vibes (11th to 12th)',
//     'Master Minds (Degree and above)'
//   ];

//   @override
//   void initState() {
//     super.initState();
//     // Initialize controllers with existing data
//     _nameController = TextEditingController(text: widget.teacherData['name']);
//     _emailController = TextEditingController(text: widget.teacherData['email']);
//     _numberController = TextEditingController(text: widget.teacherData['number']);
//     _subjectController = TextEditingController(text: widget.teacherData['subject']);
//     currentImageUrl = widget.teacherData['image'];
//     _selectedCategory = widget.teacherData['classCategory']; // Initialize category
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _numberController.dispose();
//     _subjectController.dispose();
//     super.dispose();
//   }

//   Future<String?> _uploadToCloudinary() async {
//     if (_image == null) return currentImageUrl;
//     try {
//       final url = Uri.parse('https://api.cloudinary.com/v1_1/datygsam7/upload');
//       final request = http.MultipartRequest('POST', url)
//         ..fields['upload_preset'] = 'VijayaShilpi'
//         ..files.add(await http.MultipartFile.fromPath('file', _image!.path));
//       final response = await request.send();
//       if (response.statusCode == 200) {
//         final responseData = await response.stream.toBytes();
//         final responseString = String.fromCharCodes(responseData);
//         final jsonMap = jsonDecode(responseString);
//         return jsonMap['secure_url'] as String;
//       } else {
//         throw Exception('Upload failed: ${response.statusCode}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
//       return currentImageUrl;
//     }
//   }

//   Future<void> _updateTeacher() async {
//     if (_selectedCategory == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a class category')),
//       );
//       return;
//     }

//     try {
//       String? imageUrl = await _uploadToCloudinary();
      
//       await FirebaseFirestore.instance
//           .collection('teachers_registration')
//           .doc(widget.teacherId)
//           .update({
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'number': _numberController.text.trim(),
//         'subject': _subjectController.text.trim(),
//         'classCategory': _selectedCategory,
//         'image': imageUrl,
//         'lastUpdated': FieldValue.serverTimestamp(),
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Teacher information updated successfully')),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating teacher: $e')),
//       );
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Teacher"),
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: _pickImage,
//                 child: CircleAvatar(
//                   radius: 60,
//                   backgroundColor: Colors.grey[300],
//                   backgroundImage: _image != null 
//                       ? FileImage(_image!) 
//                       : (currentImageUrl != null 
//                           ? NetworkImage(currentImageUrl!) as ImageProvider 
//                           : null),
//                   child: (_image == null && currentImageUrl == null)
//                       ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 15),
//               _buildTextField(_nameController, "Full Name", Icons.person),
//               _buildTextField(_emailController, "Email", Icons.email),
//               _buildTextField(_numberController, "Phone Number", Icons.phone),
//               _buildTextField(_subjectController, "Subject", Icons.book),
//               // Add dropdown for class category
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: DropdownButtonFormField<String>(
//                   value: _selectedCategory,
//                   decoration: InputDecoration(
//                     prefixIcon: const Icon(Icons.class_, color: Colors.blueAccent),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                     hintText: "Select Class Category",
//                   ),
//                   items: _categories.map((String category) {
//                     return DropdownMenuItem<String>(
//                       value: category,
//                       child: Text(category),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedCategory = newValue;
//                     });
//                   },
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _updateTeacher,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text(
//                     "Update",
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String hintText, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.blueAccent),
//           hintText: hintText,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vj_admin/Model/Teacher/teacherservice.dart';

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
  final TeacherService _teacherService = TeacherService();
  bool _isLoading = false;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.teacherData['name']);
    _emailController = TextEditingController(text: widget.teacherData['email']);
    _numberController = TextEditingController(text: widget.teacherData['number']);
    _selectedCategory = widget.teacherData['classCategory'];
    _selectedSubject = widget.teacherData['subject'];
    _currentImageUrl = widget.teacherData['image'];
    _fetchCategories();
    _fetchSubjects();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    super.dispose();
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

  Future<void> _updateTeacher() async {
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
      String? imageUrl = _currentImageUrl;
      if (_image != null) {
        imageUrl = await _teacherService.uploadToCloudinary(_image!);
      }

      await FirebaseFirestore.instance
          .collection('teachers_registration')
          .doc(widget.teacherId)
          .update({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'number': _numberController.text.trim(),
        'subject': _selectedSubject,
        'classCategory': _selectedCategory,
        'image': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teacher details updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating teacher: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        _buildTextField(_nameController, "Full Name", Icons.person),
                        _buildTextField(_emailController, "Email", Icons.email),
                        _buildTextField(
                            _numberController, "Phone Number", Icons.phone),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          "Select Class Category",
                          _categories,
                          _selectedCategory,
                          (value) => setState(() => _selectedCategory = value),
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          "Select Subject",
                          _subjects,
                          _selectedSubject,
                          (value) => setState(() => _selectedSubject = value),
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
                    onPressed: _isLoading ? null : _updateTeacher,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                    ),
                    child: _isLoading
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
          if (_isLoading)
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
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.amber, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }
Widget _buildDropdown(String hint, List<String> items, String? selectedValue,
    Function(String?) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: const Icon(Icons.class_, color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.amber, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      isExpanded: true, // Prevents overflow by expanding to full width
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: FittedBox(
            fit: BoxFit.scaleDown, // Scales down long text instead of overflowing
            child: Text(
              item,
              overflow: TextOverflow.ellipsis, // Shows "..." for very long text
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}

}