import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vj_admin/View/Widgets/techerdetailwidget.dart';

class TeacherDetailsPage extends StatelessWidget {
  final String teacherId;

  const TeacherDetailsPage({
    Key? key,
    required this.teacherId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('teachers_registration')
            .doc(teacherId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('Teacher not found'),
            );
          }

          final teacherData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: NetworkImage(teacherData['image'] ?? ''),
                      fit: BoxFit.cover,
                      onError: (error, stackTrace) {
                        // Handle image load error
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailItem(
                        title: 'Name',
                        content: teacherData['name'] ?? 'N/A',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      DetailItem(
                        title: 'Email',
                        content: teacherData['email'] ?? 'N/A',
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 16),
                      DetailItem(
                        title: 'Subject',
                        content: teacherData['subject'] ?? 'N/A',
                        icon: Icons.book,
                      ),
                      const SizedBox(height: 16),
                      DetailItem(
                        title: 'Class Category',
                        content: teacherData['classCategory'] ?? 'N/A',
                        icon: Icons.category,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}