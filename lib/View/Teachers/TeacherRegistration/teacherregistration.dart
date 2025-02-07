// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
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
//   final TextEditingController _subjectController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final Uuid _uuid = const Uuid();

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

//    Future<void> sendEmail(String name, String email, String password) async {
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
//         <p><em>Please change your password after your first login.</em></p>
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
//     String subject = _subjectController.text.trim();

//     if (name.isEmpty || email.isEmpty || number.isEmpty || subject.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all fields")),
//       );
//       return;
//     }

//     try {
//       // Generate password
//       String Password = "${name.toLowerCase()}@1234";
//       // String hashedPassword = hashPassword(initialPassword);
      
//       // Upload Image to Cloudinary and Get URL
//       String? imageUrl = await _uploadToCloudinary();
      
//       // Generate Unique ID
//       String uuid = FirebaseFirestore.instance.collection('teachers_registration').doc().id;

//       // Store Teacher Data in Firestore with password
//       await FirebaseFirestore.instance.collection('teachers_registration').doc(uuid).set({
//         "name": name,
//         "email": email,
//         "number": number,
//         "subject": subject,
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
//         const SnackBar(content: Text("Registration successful! Credentials sent via email.")),
//       );
//       Navigator.pop(context);
//       // Clear Fields After Success
//       _nameController.clear();
//       _emailController.clear();
//       _numberController.clear();
//       _subjectController.clear();
//       setState(() {
//         _image = null;
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Teacher Registration"),
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
//                   backgroundImage: _image != null ? FileImage(_image!) : null,
//                   child: _image == null
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
//                   onPressed: _registerTeacher,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text(
//                     "Register",
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


import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:uuid/uuid.dart';

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
  final TextEditingController _subjectController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  
  // Add class category dropdown
  String? _selectedCategory;
  final List<String> _categories = [
    'Young Minds (5th to 7th)',
    'Achievers (8th to 10th)',
    'Vibrant Vibes (11th to 12th)',
    'Master Minds (Degree and above)'
  ];

  Future<String?> _uploadToCloudinary() async {
    if (_image == null) return null;
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
      return null;
    }
  }

  Future<void> sendEmail(String name, String email, String password) async {
    String username = "jinspathrose560@gmail.com";
    String appPassword = "zhtu tofw vdvl ifur";

    final smtpServer = gmail(username, appPassword);

    final message = Message()
      ..from = Address(username, "Vijay Sirpi Admin")
      ..recipients.add(email)
      ..subject = "Welcome to Vijay Sirpi"
      ..html = """
        <h2>Welcome to Vijay Sirpi</h2>
        <p>Dear $name,</p>
        <p>Welcome! You have been successfully registered as a teacher.</p>
        <p><strong>Your login credentials:</strong></p>
        <p>Email: $email</p>
        <p>Password: $password</p>
        <p><em>Please change your password after your first login.</em></p>
        <p>Best regards,<br>Vijay Sirpi Administration</p>
      """;

    try {
      await send(message, smtpServer);
      print("Email sent successfully!");
    } catch (e) {
      print("Failed to send email: $e");
      throw Exception("Failed to send email: $e");
    }
  }

  Future<void> _registerTeacher() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String number = _numberController.text.trim();
    String subject = _subjectController.text.trim();

    if (name.isEmpty || email.isEmpty || number.isEmpty || subject.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields including class category")),
      );
      return;
    }

    try {
      // Generate password
      String Password = "${name.toLowerCase()}@1234";
      
      // Upload Image to Cloudinary and Get URL
      String? imageUrl = await _uploadToCloudinary();
      
      // Generate Unique ID
      String uuid = FirebaseFirestore.instance.collection('teachers_registration').doc().id;

      // Store Teacher Data in Firestore with password and class category
      await FirebaseFirestore.instance.collection('teachers_registration').doc(uuid).set({
        "name": name,
        "email": email,
        "number": number,
        "subject": subject,
        "classCategory": _selectedCategory,
        "image": imageUrl ?? "",
        "uuid": uuid,
        "password": Password,
        "isFirstLogin": true,
        "createdAt": FieldValue.serverTimestamp(),
        "lastUpdated": FieldValue.serverTimestamp(),
      });

      // Send Welcome Email with password
      await sendEmail(name, email, Password);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful! Credentials sent via email.")),
      );
      Navigator.pop(context);
      // Clear Fields After Success
      _nameController.clear();
      _emailController.clear();
      _numberController.clear();
      _subjectController.clear();
      setState(() {
        _image = null;
        _selectedCategory = null;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
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
        title: const Text("Teacher Registration"),
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
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
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
                  onPressed: _registerTeacher,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Register",
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