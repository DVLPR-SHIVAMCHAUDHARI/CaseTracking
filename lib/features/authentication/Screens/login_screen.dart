import 'package:casetracking/core/consts/appcolors.dart';
import 'package:casetracking/core/consts/asset_url.dart';
import 'package:casetracking/core/routes/routes.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailField = TextEditingController();
  TextEditingController passField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                      /// Color bar on top
                      Container(
                        height: 18,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue,
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
                            Text(
                              "CASE TRACKING",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                color: Colors.blueGrey[900],
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              "Log In",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),

                            SizedBox(height: 28),

                            /// Email
                            _label("Email Address / User"),
                            SizedBox(height: 6),

                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is required";
                                }
                                return null;
                              },
                              controller: emailField,
                              decoration: InputDecoration(
                                hintText: "email address / user",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            /// Password
                            _label("Password"),
                            SizedBox(height: 6),

                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is required";
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {},
                              controller: passField,
                              obscureText: true,
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

                            SizedBox(height: 30),

                            /// Submit
                            // BlocBuilder<AuthBloc, AuthState>(
                            //   builder: (context, state) {
                            //     return loginbutton(
                            //       formkey: formkey,
                            //       state: state,
                            //       context: context,
                            //       emailController: emailField,
                            //       passwordController: passField,
                            //     );
                            //   },
                            // ),
                            loginbutton(
                              formkey: formkey,
                              context: context,
                              emailController: emailField,
                              passwordController: passField,
                            ),
                            SizedBox(height: 28),
                            const Divider(),
                            SizedBox(height: 12),
                            _footer(),
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
      },
    );
  }
}

/// Reusable label
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

loginbutton({
  required GlobalKey<FormState> formkey,

  required BuildContext context,
  required TextEditingController emailController,
  required TextEditingController passwordController,
}) {
  return SizedBox(
    width: double.infinity,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: () {
        if (formkey.currentState!.validate()) {
          // Perform login action
          router.goNamed(Routes.home.name);
        }
      },
      child: const Text(
        "Submit",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    ),
  );
}

/// Footer Widget
Widget _footer() {
  return Column(
    children: [
      SizedBox(height: 50, child: Image.asset(AssetUrl.icUnimeshTechnology)),
      SizedBox(height: 4),
      Text(
        "Connecting Future!",
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
    ],
  );
}
