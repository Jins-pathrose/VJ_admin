import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vj_admin/Controller/StudentScreen/bloc/studentscreen_event.dart';
import 'package:vj_admin/Controller/StudentScreen/bloc/studentscreen_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final FirebaseFirestore _firestore;
  Stream<QuerySnapshot>? _studentsStream;
  
  StudentBloc({FirebaseFirestore? firestore}) 
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(StudentInitial()) {
    on<LoadStudents>(_onLoadStudents);
    on<SearchStudents>(_onSearchStudents);
  }

  void _onLoadStudents(LoadStudents event, Emitter<StudentState> emit) {
    emit(StudentLoading());
    try {
      _studentsStream = _firestore.collection('students_registration').snapshots();
      emit(StudentLoaded([]));
    } catch (e) {
      emit(StudentError(e.toString()));
    }
  }

  void _onSearchStudents(SearchStudents event, Emitter<StudentState> emit) {
    if (state is StudentLoaded) {
      final currentState = state as StudentLoaded;
      emit(StudentLoaded(currentState.students, searchQuery: event.query));
    }
  }

  Stream<QuerySnapshot> get studentsStream => 
      _studentsStream ?? _firestore.collection('students_registration').snapshots();
}