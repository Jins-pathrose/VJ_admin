import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vj_admin/Controller/TeacherRegistration/bloc/teacher_reg_event.dart';
import 'package:vj_admin/Controller/TeacherRegistration/bloc/teacher_reg_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TeacherBloc() : super(TeacherLoading()) {
    on<LoadTeachers>(_onLoadTeachers);
    on<DeleteTeacher>(_onDeleteTeacher);
    on<SearchTeachers>(_onSearchTeachers);
  }

  Future<void> _onLoadTeachers(LoadTeachers event, Emitter<TeacherState> emit) async {
    try {
      final snapshot = await _firestore.collection('teachers_registration').get();
      emit(TeacherLoaded(snapshot.docs));
    } catch (e) {
      emit(TeacherError("Failed to load teachers"));
    }
  }

  Future<void> _onDeleteTeacher(DeleteTeacher event, Emitter<TeacherState> emit) async {
    try {
      await _firestore.collection('teachers_registration').doc(event.teacherId).delete();
      add(LoadTeachers()); // Refresh the teacher list
    } catch (e) {
      emit(TeacherError("Failed to delete teacher"));
    }
  }

  Future<void> _onSearchTeachers(SearchTeachers event, Emitter<TeacherState> emit) async {
    try {
      final snapshot = await _firestore.collection('teachers_registration').get();
      var filteredTeachers = snapshot.docs.where((teacher) {
        final name = teacher['name'].toString().toLowerCase();
        final subject = teacher['subject'].toString().toLowerCase();
        final email = teacher['email'].toString().toLowerCase();
        final query = event.query.toLowerCase();
        return name.contains(query) || subject.contains(query) || email.contains(query);
      }).toList();

      emit(TeacherLoaded(filteredTeachers));
    } catch (e) {
      emit(TeacherError("Failed to search teachers"));
    }
  }
}