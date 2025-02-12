import 'package:equatable/equatable.dart';

abstract class TeacherDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeacherDetailsInitial extends TeacherDetailsState {}

class TeacherDetailsLoading extends TeacherDetailsState {}

class TeacherDetailsLoaded extends TeacherDetailsState {
  final Map<String, dynamic> teacherData;
  TeacherDetailsLoaded({required this.teacherData});

  @override
  List<Object?> get props => [teacherData];
}

class TeacherDetailsError extends TeacherDetailsState {
  final String message;
  TeacherDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
