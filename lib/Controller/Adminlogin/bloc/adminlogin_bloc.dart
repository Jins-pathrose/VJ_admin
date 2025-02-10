import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vj_admin/Controller/Adminlogin/bloc/adminlogin_event.dart';
import 'package:vj_admin/Controller/Adminlogin/bloc/adminlogin_state.dart';


class AdminLoginBloc extends Bloc<AdminLoginEvent, AdminLoginState> {
  AdminLoginBloc() : super(AdminLoginInitial()) {
    on<CheckLoginStatus>(_onCheckLoginStatus);
    on<LoginAttempt>(_onLoginAttempt);
  }

  // Check if admin is already logged in
  Future<void> _onCheckLoginStatus(
      CheckLoginStatus event, Emitter<AdminLoginState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isAdminLoggedIn') ?? false;
    if (isLoggedIn) {
      emit(AdminLoginSuccess());
    }
  }

  // Handle login attempt
  Future<void> _onLoginAttempt(
      LoginAttempt event, Emitter<AdminLoginState> emit) async {
    if (event.email.trim() == 'Admin@gmail.com' &&
        event.password.trim() == 'admin@1234') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAdminLoggedIn', true);
      emit(AdminLoginSuccess());
    } else {
      emit(AdminLoginFailure("Invalid email or password"));
    }
  }
}
