import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class TeacherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeacherLoading extends TeacherState {}

class TeacherLoaded extends TeacherState {
  final List<DocumentSnapshot> teachers;
  TeacherLoaded(this.teachers);

  @override
  List<Object?> get props => [teachers];
}

class TeacherError extends TeacherState {
  final String message;
  TeacherError(this.message);

  @override
  List<Object?> get props => [message];
}