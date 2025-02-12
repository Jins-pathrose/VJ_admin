
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vj_admin/Controller/TeacherRegistration/bloc/teacher_reg_bloc.dart';
import 'package:vj_admin/Controller/TeacherRegistration/bloc/teacher_reg_event.dart';
import 'package:vj_admin/Controller/TeacherRegistration/bloc/teacher_reg_state.dart';
import 'package:vj_admin/View/Teachers/TeacherRegistration/teacherregistration.dart';
import 'package:vj_admin/View/Teachers/TeacherScreen/teacherdetails.dart';
import 'package:vj_admin/View/Teachers/TeachersEdit/teachersedit.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TeacherBloc>().add(LoadTeachers());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeacherBloc, TeacherState>(
      listener: (context, state) {
        if (state is TeacherError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Teachers",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TeacherRegistration()));
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
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              context.read<TeacherBloc>().add(LoadTeachers());
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (value) {
                  context.read<TeacherBloc>().add(SearchTeachers(value));
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<TeacherBloc, TeacherState>(
                builder: (context, state) {
                  if (state is TeacherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is TeacherError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is TeacherLoaded) {
                    if (state.teachers.isEmpty) {
                      return const Center(child: Text("No teachers available"));
                    }
                    
                    return ListView.builder(
                  itemCount: state.teachers.length,
                  itemBuilder: (context, index) {
                    var teacher = state.teachers[index];
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
                              onPressed: (context) {
                                    context.read<TeacherBloc>().add(DeleteTeacher(teacherId));
                                  },
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
                                radius: 100,
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
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
