import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vj_admin/Controller/Adminlogin/bloc/adminlogin_bloc.dart';
import 'package:vj_admin/Controller/Adminlogin/bloc/adminlogin_event.dart';
import 'package:vj_admin/Controller/StudentScreen/bloc/studentscreen_bloc.dart';
import 'package:vj_admin/Controller/TeacherDetails/bloc/teacher_details_bloc.dart';
import 'package:vj_admin/Controller/TeacherEdit/bloc/teacheredit_bloc.dart';
import 'package:vj_admin/Controller/TeacherRegistration/bloc/teacher_reg_bloc.dart';
import 'package:vj_admin/Controller/TeacherRegistration/bloc/teacher_reg_event.dart';
import 'package:vj_admin/Model/Teacher/teacherservice.dart';
import 'package:vj_admin/View/AdminLogin/adminlogin.dart';
import 'package:vj_admin/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdminLoginBloc>(
          create: (context) => AdminLoginBloc()..add(CheckLoginStatus()),
        ),
        BlocProvider<TeacherBloc>(
          create: (context) => TeacherBloc()..add(LoadTeachers()),
        ),
        BlocProvider(
            create: (context) =>
                TeacherDetailsBloc(firestore: FirebaseFirestore.instance)),
        BlocProvider<TeacherEditBloc>(
          create: (context) =>
              TeacherEditBloc(teacherService: TeacherService()),
        ),
        BlocProvider<StudentBloc>(
          create: (context) => StudentBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Vijaya Sirpi Admin',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
