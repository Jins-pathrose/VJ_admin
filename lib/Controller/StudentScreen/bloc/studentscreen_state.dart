import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class StudentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<QueryDocumentSnapshot> students;
  final String searchQuery;
  
  StudentLoaded(this.students, {this.searchQuery = ''});
  
  @override
  List<Object?> get props => [students, searchQuery];
}

class StudentError extends StudentState {
  final String message;
  
  StudentError(this.message);
  
  @override
  List<Object?> get props => [message];
}