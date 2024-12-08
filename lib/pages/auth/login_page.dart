import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app_v1/components/common/custom_form_textfield.dart';
import 'package:tracking_app_v1/components/common/form_submit_button.dart';
import 'package:tracking_app_v1/pages/admin/admin_dashboard_page.dart';
import 'package:tracking_app_v1/pages/auth/register_page.dart';
import 'package:tracking_app_v1/pages/common/home_page.dart';
import 'package:tracking_app_v1/pages/common/not_found.dart';
import 'package:tracking_app_v1/providers/auth_provider_v2.dart';
import 'package:tracking_app_v1/providers/auth_state_provider.dart';
import 'package:tracking_app_v1/services/account_service.dart';
import 'package:tracking_app_v1/utils/credential_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onSubmitForm(BuildContext context) async {
    // print("Start logging in....");
    showDialog(
      context: context,
      builder: (context) => Center(
        child: const CircularProgressIndicator(),
      ),
    );
    if (_formKey.currentState!.validate()) {
      await Provider.of<AuthStateProvider>(context, listen: false)
          .login(_emailController.text, _passwordController.text);

      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => HomePage(),
      //     ));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthStateProvider>(builder: (context, auth, child) {
          var currentUser = auth.currentUser;
          /*Do not use this, conflict with stream builder*/
          // if (!currentUser!.isEmpty()) {
          //   Navigator.pop(context);
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const HomePage(),
          //       ));
          // }

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 36,
                    color: Color.fromRGBO(56, 56, 56, .9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        CustomFormTextfield(
                          controller: _emailController,
                          hintText: "Email",
                          obscureText: false,
                          validator: (value) {
                            return CredentialValidator.validateEmail(value);
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomFormTextfield(
                          controller: _passwordController,
                          hintText: "Password",
                          obscureText: true,
                          validator: (value) {
                            // return CredentialValidator.validatePassword(value);
                          },
                        ),
                        const SizedBox(height: 10),
                        FormSubmitButton(
                          context: context,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          title: "Login",
                          method: () => onSubmitForm(context),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: const TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(
                        text: "Register Here",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
