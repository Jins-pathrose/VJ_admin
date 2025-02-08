import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentDetailPage extends StatelessWidget {
  final String studentId;
  final Map<String, dynamic> studentData;

  const StudentDetailPage({
    Key? key,
    required this.studentId,
    required this.studentData,
  }) : super(key: key);

  Widget _buildInfoCard(String title, String value) {
  return SizedBox(
    width: double.infinity, // Full width
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 49, 49),
      appBar: AppBar(
        title: Text(
          'Student Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue[100],
                child: Text(
                  studentData['name']?[0].toUpperCase() ?? 'S',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard('Name', studentData['name'] ?? 'Not provided'),
            const SizedBox(height: 12),
            _buildInfoCard('School', studentData['school'] ?? 'Not provided'),
            const SizedBox(height: 12),
            _buildInfoCard('Class', studentData['class'] ?? 'Not provided'),
            const SizedBox(height: 12),
            _buildInfoCard('Number', studentData['number'] ?? 'Not provided'),
            const SizedBox(height: 12),
            _buildInfoCard('Sirpakam', studentData['sirpakam'] ?? 'Not provided'),
           
          ],
        ),
      ),
    );
  }
}