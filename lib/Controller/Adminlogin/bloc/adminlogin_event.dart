import 'package:equatable/equatable.dart';

abstract class AdminLoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckLoginStatus extends AdminLoginEvent {}

class LoginAttempt extends AdminLoginEvent {
  final String email;
  final String password;

  LoginAttempt(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}
