part of 'teacher_reg_bloc.dart';

sealed class TeacherRegState extends Equatable {
  const TeacherRegState();
  
  @override
  List<Object> get props => [];
}

final class TeacherRegInitial extends TeacherRegState {}
