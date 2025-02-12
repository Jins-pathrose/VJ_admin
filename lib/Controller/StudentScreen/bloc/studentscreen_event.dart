import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Events
abstract class StudentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadStudents extends StudentEvent {}

class SearchStudents extends StudentEvent {
  final String query;
  
  SearchStudents(this.query);
  
  @override
  List<Object?> get props => [query];
}