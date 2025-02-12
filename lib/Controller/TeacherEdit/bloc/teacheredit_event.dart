// teacher_edit_bloc.dart
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vj_admin/Model/Teacher/teacherservice.dart';

// Events
abstract class TeacherEditEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateTeacherDetails extends TeacherEditEvent {
  final String teacherId;
  final String name;
  final String email;
  final String number;
  final String category;
  final String subject;
  final File? newImage;
  final String? currentImageUrl;

  UpdateTeacherDetails({
    required this.teacherId,
    required this.name,
    required this.email,
    required this.number,
    required this.category,
    required this.subject,
    this.newImage,
    this.currentImageUrl,
  });

  @override
  List<Object?> get props => [teacherId, name, email, number, category, subject, newImage, currentImageUrl];
}

class FetchCategories extends TeacherEditEvent {}

class FetchSubjects extends TeacherEditEvent {}