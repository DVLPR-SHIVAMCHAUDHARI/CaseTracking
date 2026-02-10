import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/core/consts/asset_url.dart';
import 'package:casetracking/core/consts/snack_bar.dart';
import 'package:casetracking/core/routes/routes.dart';
import 'package:casetracking/features/authentication/bloc/auth_bloc.dart';
import 'package:casetracking/features/authentication/bloc/auth_event.dart';
import 'package:casetracking/features/authentication/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController emailField = TextEditingController();
  final TextEditingController passField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 420,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// TOP COLOR BAR
                  Container(
                    height: 18,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 36,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "CASE TRACKING",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// EMAIL
                        _label("Email Address / User"),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: emailField,
                          validator: (value) => value == null || value.isEmpty
                              ? "This field is required"
                              : null,
                          decoration: InputDecoration(
                            hintText: "email / username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// PASSWORD
                        _label("Password"),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: passField,
                          obscureText: true,
                          validator: (value) => value == null || value.isEmpty
                              ? "This field is required"
                              : null,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// SUBMIT
                        BlocListener<AuthBloc, AuthState>(
                          listenWhen: (previous, current) =>
                              current is LoginSuccessState ||
                              current is LoginFailureState,
                          listener: (context, state) {
                            if (state is LoginFailureState) {
                              snackbar(
                                context,
                                message: state.error,
                                color: Colors.red,
                              );
                            }
                            if (state is LoginSuccessState) {
                              router.goNamed(Routes.home.name);

                              snackbar(
                                title: "Great",
                                context,
                                message: state.message,
                                color: Colors.green,
                              );
                            }
                          },

                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    LoginEvent(
                                      username: emailField.text.trim(),
                                      password: passField.text.trim(),
                                    ),
                                  );
                                }
                              },
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  if (state is LoginLoadingState) {
                                    return const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    );
                                  }
                                  return Text(
                                    "Submit",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),
                        const Divider(),
                        const SizedBox(height: 12),

                        /// FOOTER
                        Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Image.asset(AssetUrl.icUnimeshTechnology),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Connecting Future!",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// LABEL
Widget _label(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[700],
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
