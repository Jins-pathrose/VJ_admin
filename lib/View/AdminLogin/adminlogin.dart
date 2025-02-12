

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vj_admin/Controller/Adminlogin/bloc/adminlogin_bloc.dart';
import 'package:vj_admin/Controller/Adminlogin/bloc/adminlogin_event.dart';
import 'package:vj_admin/Controller/Adminlogin/bloc/adminlogin_state.dart';
import 'package:vj_admin/Model/Validation/validation.dart';
import 'package:vj_admin/View/BottomNavigation/bottomnavigation.dart';


class AdminLogin extends StatelessWidget {
  AdminLogin({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminLoginBloc()..add(CheckLoginStatus()),
      child: Scaffold(
        body: BlocListener<AdminLoginBloc, AdminLoginState>(
          listener: (context, state) {
            if (state is AdminLoginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavigation()),
              );
            } else if (state is AdminLoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 42, 0),
                  Color.fromARGB(255, 226, 242, 1)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome Admin!",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Card(
                    color: const Color.fromARGB(255, 187, 219, 234),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email, color: Colors.black),
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock, color: Colors.black),
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) => ValidationHelper.validatePassword(value),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: BlocBuilder<AdminLoginBloc, AdminLoginState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AdminLoginBloc>().add(
                                            LoginAttempt(
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
                                            ),
                                          );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: state is AdminLoginLoading
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text(
                                          "Login",
                                          style: TextStyle(color: Colors.white, fontSize: 18),
                                        ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
