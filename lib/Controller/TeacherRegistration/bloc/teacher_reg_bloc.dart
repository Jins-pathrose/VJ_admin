import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'teacher_reg_event.dart';
part 'teacher_reg_state.dart';

class TeacherRegBloc extends Bloc<TeacherRegEvent, TeacherRegState> {
  TeacherRegBloc() : super(TeacherRegInitial()) {
    on<TeacherRegEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
