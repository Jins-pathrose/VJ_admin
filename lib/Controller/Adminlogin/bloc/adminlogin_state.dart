import 'package:equatable/equatable.dart';

abstract class AdminLoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class AdminLoginInitial extends AdminLoginState {}

class AdminLoginLoading extends AdminLoginState {}

class AdminLoginSuccess extends AdminLoginState {}

class AdminLoginFailure extends AdminLoginState {
  final String message;

  AdminLoginFailure(this.message);

  @override
  List<Object> get props => [message];
}
