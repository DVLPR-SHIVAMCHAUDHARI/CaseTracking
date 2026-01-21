import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/core/consts/snack_bar.dart';
import 'package:casetracking/features/authentication/bloc/auth_bloc.dart';
import 'package:casetracking/features/authentication/bloc/auth_event.dart';
import 'package:casetracking/features/authentication/bloc/auth_state.dart';
import 'package:casetracking/features/master_api/department/bloc/department_bloc.dart';
import 'package:casetracking/features/master_api/department/bloc/department_state.dart';
import 'package:casetracking/features/master_api/models/department_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({
    super.key,
    required this.userId,
    required this.fullname,
    required this.email,
    required this.departmentId,
  });

  final int userId;
  final String fullname;
  final String email;
  final int departmentId;

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController emailController;

  int? selectedDepartmentId;

  @override
  void initState() {
    super.initState();

    idController = TextEditingController(text: widget.userId.toString());
    nameController = TextEditingController(text: widget.fullname);
    emailController = TextEditingController(text: widget.email);
    selectedDepartmentId = widget.departmentId;
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Update User"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UpdateUserFailureState) {
            snackbar(context, message: state.error, color: Colors.red);
          }

          if (state is UpdateUserSuccessState) {
            snackbar(
              context,
              title: "Great",
              message: state.message,
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
                    _label("User ID"),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: idController,
                      readOnly: true,
                      decoration: _inputDecoration("User ID"),
                    ),

                    const SizedBox(height: 20),

                    _label("Full Name"),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: nameController,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                      decoration: _inputDecoration("Enter full name"),
                    ),

                    const SizedBox(height: 20),

                    _label("Email"),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: emailController,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                      decoration: _inputDecoration("Enter email"),
                    ),

                    const SizedBox(height: 20),

                    _label("Department"),
                    const SizedBox(height: 6),

                    BlocBuilder<DepartmentBloc, DepartmentState>(
                      builder: (context, state) {
                        if (state is DepartmentLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is DepartmentError) {
                          return Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          );
                        }

                        if (state is DepartmentLoaded) {
                          return DropdownButtonFormField<int>(
                            value: selectedDepartmentId,
                            decoration: _inputDecoration("Select department"),
                            items: state.departments.map((dept) {
                              return DropdownMenuItem<int>(
                                value: dept.id,
                                child: Text(dept.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() => selectedDepartmentId = value);
                            },
                            validator: (value) =>
                                value == null ? "Required" : null,
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            onPressed: state is UpdateUserLoadingState
                                ? null
                                : _submit,
                            child: state is UpdateUserLoadingState
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Update User",
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
        UpdateUserEvent(
          id: widget.userId,
          fullname: nameController.text.trim(),
          email: emailController.text.trim(),
          departmentId: selectedDepartmentId!,
        ),
      );
    }
  }
}

/// UI HELPERS
InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );
}

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
