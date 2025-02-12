import 'package:equatable/equatable.dart';

abstract class TeacherDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTeacherDetails extends TeacherDetailsEvent {
  final String teacherId;
  LoadTeacherDetails({required this.teacherId});

  @override
  List<Object?> get props => [teacherId];
}
