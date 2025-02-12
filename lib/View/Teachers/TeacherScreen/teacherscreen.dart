// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:vj_admin/View/Teachers/TeacherRegistration/teacherregistration.dart';
// import 'package:vj_admin/View/Teachers/TeacherScreen/teacherdetails.dart';
// import 'package:vj_admin/View/Teachers/TeachersEdit/teachersedit.dart';

// class TeacherScreen extends StatefulWidget {
//   const TeacherScreen({super.key});

//   @override
//   State<TeacherScreen> createState() => _TeacherScreenState();
// }

// class _TeacherScreenState extends State<TeacherScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> _deleteTeacher(String teacherId) async {
//     await _firestore
//         .collection('teachers_registration')
//         .doc(teacherId)
//         .delete();
//     ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Teacher deleted successfully")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Teachers",
//           style: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         backgroundColor: const Color.fromARGB(255, 0, 0, 0),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => const TeacherRegistration()),
//           );
//         },
//         backgroundColor: Colors.amber,
//         child:
//             const Icon(Icons.person_add, color: Color.fromARGB(255, 0, 0, 0)),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore.collection('teachers_registration').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text("No teachers available"));
//           }

//           var teachers = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: teachers.length,
//             itemBuilder: (context, index) {
//               var teacher = teachers[index];
//               String teacherId = teacher.id;
//               String name = teacher['name'];
//               String email = teacher['email'];
//               String number = teacher['number'];
//               String subject = teacher['subject'];
//               String imageUrl = teacher['image'];

//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 child: Slidable(
//                   endActionPane: ActionPane(
//                     motion: const ScrollMotion(),
//                     children: [
//                       SlidableAction(
//                         onPressed: (context) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => TeacherEdit(
//                                 teacherId: teacherId,
//                                 teacherData: {
//                                   'name': name,
//                                   'email': email,
//                                   'number': number,
//                                   'subject': subject,
//                                   'image': imageUrl,
//                                   'classCategory': teacher['classCategory'],
//                                 },
//                               ),
//                             ),
//                           );
//                         },
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         icon: Icons.edit,
//                         label: 'Edit',
//                       ),
//                       SlidableAction(
//                         onPressed: (context) => _deleteTeacher(teacherId),
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         icon: Icons.delete,
//                         label: 'Delete',
//                       ),
//                     ],
//                   ),
//                   child: Card(
//                     margin: const EdgeInsets.symmetric(horizontal: 10),
//                     child: ListTile(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => TeacherDetailsPage(
//                               teacherId: teacherId,
//                             ),
//                           ),
//                         );
//                       },
//                       leading: Container(
//                         width: 50,
//                         height: 50,
//                         child: CircleAvatar(
//                           backgroundImage: NetworkImage(imageUrl),
//                           backgroundColor: Colors.grey[300],
//                         ),
//                       ),
//                       title: Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: Text(
//                           name,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             subject,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             number,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             email,
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ],
//                       ),
//                       contentPadding: const EdgeInsets.all(16),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vj_admin/View/Teachers/TeacherRegistration/teacherregistration.dart';
import 'package:vj_admin/View/Teachers/TeacherScreen/teacherdetails.dart';
import 'package:vj_admin/View/Teachers/TeachersEdit/teachersedit.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteTeacher(String teacherId) async {
    await _firestore.collection('teachers_registration').doc(teacherId).delete();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Teacher deleted successfully")));
  }

  bool _teacherMatchesSearch(DocumentSnapshot teacher) {
    final String name = teacher['name'].toString().toLowerCase();
    final String subject = teacher['subject'].toString().toLowerCase();
    final String email = teacher['email'].toString().toLowerCase();
    final query = _searchQuery.toLowerCase();

    return name.contains(query) || subject.contains(query) || email.contains(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Teachers",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TeacherRegistration()),
          );
        },
        backgroundColor: Colors.amber,
        child: const Icon(Icons.person_add, color: Color.fromARGB(255, 0, 0, 0)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, subject, or email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('teachers_registration').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No teachers available"));
                }

                var teachers = snapshot.data!.docs;
                var filteredTeachers =
                    teachers.where((teacher) => _teacherMatchesSearch(teacher)).toList();

                if (filteredTeachers.isEmpty) {
                  return const Center(child: Text("No matching teachers found"));
                }

                return ListView.builder(
                  itemCount: filteredTeachers.length,
                  itemBuilder: (context, index) {
                    var teacher = filteredTeachers[index];
                    String teacherId = teacher.id;
                    String name = teacher['name'];
                    String email = teacher['email'];
                    String number = teacher['number'];
                    String subject = teacher['subject'];
                    String imageUrl = teacher['image'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TeacherEdit(
                                      teacherId: teacherId,
                                      teacherData: {
                                        'name': name,
                                        'email': email,
                                        'number': number,
                                        'subject': subject,
                                        'image': imageUrl,
                                        'classCategory': teacher['classCategory'],
                                      },
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) => _deleteTeacher(teacherId),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeacherDetailsPage(
                                    teacherId: teacherId,
                                  ),
                                ),
                              );
                            },
                            leading: Container(
                              width: 50,
                              height: 50,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(imageUrl),
                                backgroundColor: Colors.grey[300],
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  number,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  email,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}