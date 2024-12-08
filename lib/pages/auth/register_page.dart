import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tracking_app_v1/components/common/custom_form_textfield.dart';
import 'package:tracking_app_v1/components/common/form_submit_button.dart';
import 'package:tracking_app_v1/components/notifications/show_notification_dialog.dart';
import 'package:tracking_app_v1/services/account_service.dart';
import 'package:tracking_app_v1/utils/credential_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void submitForm() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: const CircularProgressIndicator(),
      ),
    );
    if (_formKey.currentState!.validate()) {
      // print("Start to regist user");
      try {
        var result = await registUser(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          // _phoneNumberController.text
        );

        if (result.isSuccess) {
          if (!mounted) return;
          print("Register success");
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          throw new Exception("Register fail");
        }
        return;
      } catch (e) {
        print("Register error: $e");
        Navigator.pop(context);
      }
    }
    if (!mounted) return;

    // errorDialog(
    //   context: context,
    //   statusCode: result.statusCode,
    //   description: result.errorMessage,
    //   color: Colors.green,
    // );
    showValidateError(
        context, "Warning", "Sorry something went wrong. Please try again!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Register",
              style: TextStyle(
                fontSize: 36,
                color: Color.fromRGBO(56, 56, 56, .9),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomFormTextfield(
                      controller: _nameController,
                      hintText: "Your full name",
                      obscureText: false,
                      validator: (value) {
                        return CredentialValidator.validateFullName(
                            value ?? "");
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextfield(
                      controller: _emailController,
                      hintText: "Your email",
                      obscureText: false,
                      validator: (value) {
                        return CredentialValidator.validateEmail(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomFormTextfield(
                      controller: _passwordController,
                      hintText: "Password here",
                      obscureText: true,
                      validator: (value) {
                        return CredentialValidator.validatePassword(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    // CustomFormTextfield(
                    //   controller: _phoneNumberController,
                    //   hintText: "Phone number (optional)",
                    //   obscureText: false,
                    //   validator: (value) {
                    //     return CredentialValidator.validatePhone(value);
                    //   },
                    // ),
                    // const SizedBox(height: 10),
                    FormSubmitButton(
                      context: context,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      title: "Register",
                      method: submitForm,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                text: "Already have an account? ",
                style: const TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                    text: "Login Here",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pop();
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
