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

//   @override
//   void initState() {
//     super.initState();
//     // Initialize controllers with existing data
//     _nameController = TextEditingController(text: widget.teacherData['name']);
//     _emailController = TextEditingController(text: widget.teacherData['email']);
//     _numberController = TextEditingController(text: widget.teacherData['number']);
//     _subjectController = TextEditingController(text: widget.teacherData['subject']);
//     currentImageUrl = widget.teacherData['image'];
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
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditTeacher extends StatefulWidget {
  final String teacherId;
  final Map<String, dynamic> teacherData;

  const EditTeacher({
    Key? key,
    required this.teacherId,
    required this.teacherData,
  }) : super(key: key);

  @override
  State<EditTeacher> createState() => _EditTeacherState();
}

class _EditTeacherState extends State<EditTeacher> {
  File? _image;
  final picker = ImagePicker();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _numberController;
  late TextEditingController _subjectController;
  String? currentImageUrl;
  
  // Add class category
  String? _selectedCategory;
  final List<String> _categories = [
    'Young Minds (5th to 7th)',
    'Achievers (8th to 10th)',
    'Vibrant Vibes (11th to 12th)',
    'Master Minds (Degree and above)'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _nameController = TextEditingController(text: widget.teacherData['name']);
    _emailController = TextEditingController(text: widget.teacherData['email']);
    _numberController = TextEditingController(text: widget.teacherData['number']);
    _subjectController = TextEditingController(text: widget.teacherData['subject']);
    currentImageUrl = widget.teacherData['image'];
    _selectedCategory = widget.teacherData['classCategory']; // Initialize category
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<String?> _uploadToCloudinary() async {
    if (_image == null) return currentImageUrl;
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/datygsam7/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'VijayaShilpi'
        ..files.add(await http.MultipartFile.fromPath('file', _image!.path));
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        return jsonMap['secure_url'] as String;
      } else {
        throw Exception('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
      return currentImageUrl;
    }
  }

  Future<void> _updateTeacher() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a class category')),
      );
      return;
    }

    try {
      String? imageUrl = await _uploadToCloudinary();
      
      await FirebaseFirestore.instance
          .collection('teachers_registration')
          .doc(widget.teacherId)
          .update({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'number': _numberController.text.trim(),
        'subject': _subjectController.text.trim(),
        'classCategory': _selectedCategory,
        'image': imageUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teacher information updated successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating teacher: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Teacher"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _image != null 
                      ? FileImage(_image!) 
                      : (currentImageUrl != null 
                          ? NetworkImage(currentImageUrl!) as ImageProvider 
                          : null),
                  child: (_image == null && currentImageUrl == null)
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField(_nameController, "Full Name", Icons.person),
              _buildTextField(_emailController, "Email", Icons.email),
              _buildTextField(_numberController, "Phone Number", Icons.phone),
              _buildTextField(_subjectController, "Subject", Icons.book),
              // Add dropdown for class category
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.class_, color: Colors.blueAccent),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintText: "Select Class Category",
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateTeacher,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Update",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}