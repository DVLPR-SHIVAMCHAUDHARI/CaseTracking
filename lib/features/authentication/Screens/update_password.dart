import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/core/consts/snack_bar.dart';
import 'package:casetracking/features/authentication/bloc/auth_bloc.dart';
import 'package:casetracking/features/authentication/bloc/auth_event.dart';
import 'package:casetracking/features/authentication/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdatePasswordScreen extends StatefulWidget {
  UpdatePasswordScreen({super.key, required this.userid});
  int userid;
  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscure = true;

  @override
  void initState() {
    super.initState();
    userIdController.text = widget.userid.toString();
  }

  @override
  void dispose() {
    userIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Update Password"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UpdatePasswordFailureState) {
            snackbar(context, message: state.error, color: Colors.red);
          }

          if (state is UpdatePasswordSuccessState) {
            snackbar(
              context,
              message: state.message,
              title: "Great",
              color: Colors.green,
            );
            Navigator.pop(context);
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(24),
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
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Change User Password",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// USER ID
                    _label("User ID"),
                    const SizedBox(height: 6),
                    TextFormField(
                      readOnly: true,

                      controller: userIdController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                      decoration: _inputDecoration("Enter user id"),
                    ),

                    const SizedBox(height: 20),

                    /// PASSWORD
                    _label("New Password"),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscure,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                      decoration: _inputDecoration("Enter new password")
                          .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() => obscure = !obscure);
                              },
                            ),
                          ),
                    ),

                    const SizedBox(height: 30),

                    /// SUBMIT
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            onPressed: state is UpdatePasswordLoadingState
                                ? null
                                : _submit,
                            child: state is UpdatePasswordLoadingState
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Update Password",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        UpdatePasswordEvent(
          userId: int.parse(userIdController.text.trim()),
          newPassword: passwordController.text.trim(),
        ),
      );
    }
  }
}

/// HELPERS
Widget _label(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 14,
      color: Colors.grey[700],
      fontWeight: FontWeight.w500,
    ),
  );
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );
}
