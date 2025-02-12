import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'teacher_details_event.dart';
import 'teacher_details_state.dart';

class TeacherDetailsBloc extends Bloc<TeacherDetailsEvent, TeacherDetailsState> {
  final FirebaseFirestore firestore;

  TeacherDetailsBloc({required this.firestore}) : super(TeacherDetailsInitial()) {
    on<LoadTeacherDetails>((event, emit) async {
      emit(TeacherDetailsLoading());
      try {
        DocumentSnapshot snapshot = await firestore
            .collection('teachers_registration')
            .doc(event.teacherId)
            .get();

        if (!snapshot.exists) {
          emit(TeacherDetailsError(message: "Teacher not found"));
          return;
        }

        emit(TeacherDetailsLoaded(teacherData: snapshot.data() as Map<String, dynamic>));
      } catch (e) {
        emit(TeacherDetailsError(message: e.toString()));
      }
    });
  }
}
