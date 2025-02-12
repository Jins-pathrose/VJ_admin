import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vj_admin/Controller/TeacherEdit/bloc/teacheredit_event.dart';
import 'package:vj_admin/Controller/TeacherEdit/bloc/teacheredit_state.dart';
import 'package:vj_admin/Model/Teacher/teacherservice.dart';

class TeacherEditBloc extends Bloc<TeacherEditEvent, TeacherEditState> {
  final TeacherService _teacherService;
  
  TeacherEditBloc({required TeacherService teacherService}) 
      : _teacherService = teacherService,
        super(TeacherEditInitial()) {
    on<UpdateTeacherDetails>(_onUpdateTeacherDetails);
    on<FetchCategories>(_onFetchCategories);
    on<FetchSubjects>(_onFetchSubjects);
  }

  Future<void> _onUpdateTeacherDetails(
    UpdateTeacherDetails event,
    Emitter<TeacherEditState> emit,
  ) async {
    emit(TeacherEditLoading());
    try {
      String? imageUrl = event.currentImageUrl;
      if (event.newImage != null) {
        imageUrl = await _teacherService.uploadToCloudinary(event.newImage!);
      }

      await FirebaseFirestore.instance
          .collection('teachers_registration')
          .doc(event.teacherId)
          .update({
        'name': event.name.trim(),
        'email': event.email.trim(),
        'number': event.number.trim(),
        'subject': event.subject,
        'classCategory': event.category,
        'image': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      emit(TeacherEditSuccess());
    } catch (e) {
      emit(TeacherEditFailure(e.toString()));
    }
  }

  Future<void> _onFetchCategories(
    FetchCategories event,
    Emitter<TeacherEditState> emit,
  ) async {
    try {
      final categories = await _teacherService.fetchCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(TeacherEditFailure(e.toString()));
    }
  }

  Future<void> _onFetchSubjects(
    FetchSubjects event,
    Emitter<TeacherEditState> emit,
  ) async {
    try {
      final subjects = await _teacherService.fetchSubjects();
      emit(SubjectsLoaded(subjects));
    } catch (e) {
      emit(TeacherEditFailure(e.toString()));
    }
  }
}