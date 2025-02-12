
import 'package:equatable/equatable.dart';

// Events
abstract class TeacherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTeachers extends TeacherEvent {}

class DeleteTeacher extends TeacherEvent {
  final String teacherId;
  DeleteTeacher(this.teacherId);

  @override
  List<Object?> get props => [teacherId];
}

class SearchTeachers extends TeacherEvent {
  final String query;
  SearchTeachers(this.query);

  @override
  List<Object?> get props => [query];
}