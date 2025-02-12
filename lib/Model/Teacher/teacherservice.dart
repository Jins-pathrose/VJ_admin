
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:uuid/uuid.dart';

class TeacherService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();
  final http.Client _client = http.Client();

  Future<List<String>> fetchCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('categories').get();
      return querySnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
          .toList();
    } catch (e) {
      throw Exception("Error fetching categories: $e");
    }
  }

  Future<List<String>> fetchSubjects() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('subject').get();
      return querySnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['subject'] as String)
          .toList();
    } catch (e) {
      throw Exception("Error fetching subjects: $e");
    }
  }

  Future<void> addCategory(String name) async {
    await _firestore.collection('categories').add({"name": name});
  }

  Future<void> addSubject(String subject) async {
    await _firestore.collection('subject').add({"subject": subject});
  }

  Future<void> addNewCategory(BuildContext context, Function fetchCategories) async {
    String? categoryName = await _showCategoryDialog(context);
    if (categoryName != null && categoryName.isNotEmpty) {
      await addCategory(categoryName);
      fetchCategories();
    }
  }

  Future<void> addNewSubject(BuildContext context, Function fetchSubjects) async {
    String? subjectName = await _showSubjectDialog(context);
    if (subjectName != null && subjectName.isNotEmpty) {
      await addSubject(subjectName);
      fetchSubjects();
    }
  }

  Future<String?> _showCategoryDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Category"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter category name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showSubjectDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Subject"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter subject name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<String?> uploadToCloudinary(File image) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/datygsam7/upload');

      var request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'VijayaShilpi'
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      var streamedResponse = await _client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return jsonMap['secure_url'] as String;
      } else {
        throw Exception('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
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
        <p>Best regards,<br>Vijay Sirpi Administration</p>
      """;
    try {
      await send(message, smtpServer);
    } catch (e) {
      throw Exception("Failed to send email: $e");
    }
  }

  Future<void> registerTeacher({
    required BuildContext context,
    required String name,
    required String email,
    required String number,
    required String subject,
    required String category,
    File? image,
  }) async {
    try {
      String password = "${name.toLowerCase()}@1234";
      String? imageUrl;
      
      if (image != null) {
        imageUrl = await uploadToCloudinary(image);
      }

      String uuid = _firestore.collection('teachers_registration').doc().id;

      await _firestore.collection('teachers_registration').doc(uuid).set({
        "name": name,
        "email": email,
        "number": number,
        "subject": subject,
        "classCategory": category,
        "image": imageUrl ?? "",
        "uuid": uuid,
        "password": password,
        "isFirstLogin": true,
        "createdAt": FieldValue.serverTimestamp(),
      });

      await sendEmail(name, email, password);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teacher registered successfully!')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      throw Exception("Error saving teacher data: $e");
    }
  }
  
}