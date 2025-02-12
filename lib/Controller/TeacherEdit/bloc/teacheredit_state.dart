import 'package:equatable/equatable.dart';

abstract class TeacherEditState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeacherEditInitial extends TeacherEditState {}

class TeacherEditLoading extends TeacherEditState {}

class TeacherEditSuccess extends TeacherEditState {}

class TeacherEditFailure extends TeacherEditState {
  final String error;
  TeacherEditFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class CategoriesLoaded extends TeacherEditState {
  final List<String> categories;
  CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class SubjectsLoaded extends TeacherEditState {
  final List<String> subjects;
  SubjectsLoaded(this.subjects);

  @override
  List<Object?> get props => [subjects];
}