// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';
// import 'package:uuid/uuid.dart';

// class TeacherRegistration extends StatefulWidget {
//   const TeacherRegistration({super.key});

//   @override
//   State<TeacherRegistration> createState() => _TeacherRegistrationState();
// }

// class _TeacherRegistrationState extends State<TeacherRegistration> {
//   File? _image;
//   final picker = ImagePicker();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _numberController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final Uuid _uuid = const Uuid();

//   // Add class category dropdown
//   String? _selectedCategory;
//   String? _selectedSubject;
//    List<String> _categories = [];
//    List<String> _subject = [];
// @override
// void initState() {
//   super.initState();
//   _fetchCategories();
//   _fetchsubject(); // Fetch subjects on screen load
// }

// Future<void> _fetchCategories() async {
//   try {
//     QuerySnapshot querySnapshot =
//         await _firestore.collection('categories').get();
//     setState(() {
//       _categories = querySnapshot.docs
//           .map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
//           .toList();
//     });
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Error fetching categories: $e")),
//     );
//   }
// }
// Future<void> _fetchsubject() async {
//   try {
//     QuerySnapshot querySnapshot =
//         await _firestore.collection('subject').get();
//     setState(() {
//       _subject = querySnapshot.docs
//           .map((doc) => (doc.data() as Map<String, dynamic>)['subject'] as String)
//           .toList();
//     });
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Error fetching subject: $e")),
//     );
//   }
// }

//   Future<String?> _uploadToCloudinary() async {
//     if (_image == null) return null;
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
//       return null;
//     }
//   }

//   Future<void> sendEmail(String name, String email, String password) async {
//     String username = "jinspathrose560@gmail.com";
//     String appPassword = "zhtu tofw vdvl ifur";

//     final smtpServer = gmail(username, appPassword);

//     final message = Message()
//       ..from = Address(username, "Vijay Sirpi Admin")
//       ..recipients.add(email)
//       ..subject = "Welcome to Vijay Sirpi"
//       ..html = """
//         <h2>Welcome to Vijay Sirpi</h2>
//         <p>Dear $name,</p>
//         <p>Welcome! You have been successfully registered as a teacher.</p>
//         <p><strong>Your login credentials:</strong></p>
//         <p>Email: $email</p>
//         <p>Password: $password</p>
//         <p>Best regards,<br>Vijay Sirpi Administration</p>
//       """;

//     try {
//       await send(message, smtpServer);
//       print("Email sent successfully!");
//     } catch (e) {
//       print("Failed to send email: $e");
//       throw Exception("Failed to send email: $e");
//     }
//   }

//   Future<void> _registerTeacher() async {
//     String name = _nameController.text.trim();
//     String email = _emailController.text.trim();
//     String number = _numberController.text.trim();

//     if (name.isEmpty ||
//         email.isEmpty ||
//         number.isEmpty ||
//         _selectedSubject == null ||
//         _selectedCategory == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Please fill all fields including class category")),
//       );
//       return;
//     }

//     try {
//       // Generate password
//       String Password = "${name.toLowerCase()}@1234";

//       // Upload Image to Cloudinary and Get URL
//       String? imageUrl = await _uploadToCloudinary();

//       // Generate Unique ID
//       String uuid = FirebaseFirestore.instance
//           .collection('teachers_registration')
//           .doc()
//           .id;

//       // Store Teacher Data in Firestore with password and class category
//       await FirebaseFirestore.instance
//           .collection('teachers_registration')
//           .doc(uuid)
//           .set({
//         "name": name,
//         "email": email,
//         "number": number,
//         "subject": _selectedSubject,
//         "classCategory": _selectedCategory,
//         "image": imageUrl ?? "",
//         "uuid": uuid,
//         "password": Password,
//         "isFirstLogin": true,
//         "createdAt": FieldValue.serverTimestamp(),
//         "lastUpdated": FieldValue.serverTimestamp(),
//       });

//       // Send Welcome Email with password
//       await sendEmail(name, email, Password);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content:
//                 Text("Registration successful! Credentials sent via email.")),
//       );
//       Navigator.pop(context);
//       // Clear Fields After Success
//       _nameController.clear();
//       _emailController.clear();
//       _numberController.clear();

//       setState(() {
//         _image = null;
//         _selectedCategory = null;
//         _selectedSubject = null;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $e")),
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

//   // Function to show dialog for adding a new category
// Future<void> _addNewCategory() async {
//   TextEditingController _newCategoryController = TextEditingController();
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text("Add New Category"),
//         content: TextField(
//           controller: _newCategoryController,
//           decoration: const InputDecoration(hintText: "Enter category name"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () async {
//               String newCategory = _newCategoryController.text.trim();
//               if (newCategory.isNotEmpty) {
//                 try {
//                   // Add the category to Firestore
//                   DocumentReference docRef = await _firestore
//                       .collection('categories')
//                       .add({"name": newCategory});

//                   setState(() {
//                     _categories.add(newCategory);
//                     _selectedCategory = newCategory;
//                   });

//                   Navigator.pop(context);
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Error adding category: $e")),
//                   );
//                 }
//               }
//             },
//             child: const Text("Add"),
//           ),
//         ],
//       );
//     },
//   );
// }
// Future<void> _addNewSubject() async {
//   TextEditingController _newSubjectController = TextEditingController();
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text("Add New Subject"),
//         content: TextField(
//           controller: _newSubjectController,
//           decoration: const InputDecoration(hintText: "Enter Subject"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () async {
//               String newSubject = _newSubjectController.text.trim();
//               if (newSubject.isNotEmpty) {
//                 try {
//                   await _firestore.collection('subject').add({"subject": newSubject});

//                   // Fetch subjects again to update the dropdown
//                   await _fetchsubject();

//                   Navigator.pop(context);
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Error adding subject: $e")),
//                   );
//                 }
//               }
//             },
//             child: const Text("Add"),
//           ),
//         ],
//       );
//     },
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Teacher Registration",
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 0, 0, 0),
//         iconTheme: const IconThemeData(
//           color: Colors.white, // Change back button color to white
//         ),
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
//                   backgroundColor: const Color.fromARGB(255, 194, 192, 192),
//                   backgroundImage: _image != null ? FileImage(_image!) : null,
//                   child: _image == null
//                       ? const Icon(Icons.camera_alt,
//                           size: 40, color: Color.fromARGB(255, 0, 0, 0))
//                       : null,
//                 ),
//               ),
//               const SizedBox(height: 15),
//               _buildTextField(_nameController, "Full Name", Icons.person),
//               _buildTextField(_emailController, "Email", Icons.email),
//               _buildTextField(_numberController, "Phone Number", Icons.phone),
//               // Add dropdown for class category
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Column(
//                   children: [
//                     DropdownButtonFormField<String>(
//                       value: _selectedCategory,
//                       decoration: InputDecoration(
//                         prefixIcon: const Icon(Icons.class_,
//                             color: Color.fromARGB(255, 0, 0, 0)),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         hintText: "Select Class Category",
//                       ),
//                       items: _categories.map((String category) {
//                         return DropdownMenuItem<String>(
//                           value: category,
//                           child: Text(category),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _selectedCategory = newValue;
//                         });
//                       },
//                     ),
//                     TextButton(
//                       onPressed: _addNewCategory,
//                       child: const Text("Add New Category"),
//                     ),

//                      DropdownButtonFormField<String>(
//                       value: _selectedCategory,
//                       decoration: InputDecoration(
//                         prefixIcon: const Icon(Icons.class_,
//                             color: Color.fromARGB(255, 0, 0, 0)),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10)),
//                         hintText: "Select Subject",
//                       ),
//                       items: _subject.map((String category) {
//                         return DropdownMenuItem<String>(
//                           value: category,
//                           child: Text(category),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           _selectedCategory = newValue;
//                         });
//                       },
//                     ),
//                     TextButton(
//                       onPressed: _addNewSubject,
//                       child: const Text("Add New Subject"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: _registerTeacher,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.amber,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text(
//                     "Register",
//                     style: TextStyle(
//                         fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//       TextEditingController controller, String hintText, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
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
import 'package:vj_admin/Model/Teacher/teacherservice.dart';
import 'package:vj_admin/Model/Validation/validation.dart';

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
                _buildTextField(_nameController, "Full Name", Icons.person),
                _buildTextField(_emailController, "Email", Icons.email),
                _buildTextField(_numberController, "Phone Number", Icons.phone),
                _buildDropdown(
                    "Select Class Category", _categories, _selectedCategory,
                    (value) {
                  setState(() => _selectedCategory = value);
                }),
                TextButton(
                  onPressed: () =>
                      _teacherService.addNewCategory(context, _fetchCategories),
                  child: const Text("Add New Category"),
                ),
                _buildDropdown("Select Subject", _subjects, _selectedSubject,
                    (value) {
                  setState(() => _selectedSubject = value);
                }),
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
                            style: TextStyle(fontSize: 18, color: Colors.black)),
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

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
          prefixIcon: const Icon(Icons.class_, color: Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: hint,
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}