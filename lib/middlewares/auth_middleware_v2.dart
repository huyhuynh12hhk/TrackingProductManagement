import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app_v1/pages/auth/login_page.dart';
import 'package:tracking_app_v1/providers/auth_provider_v2.dart';

class AuthMiddleware extends StatefulWidget {
  final Widget onAuthChild;
  // final Widget unAuthChild;
  const AuthMiddleware({
    super.key,
    required this.onAuthChild,
    // required this.unAuthChild,
  });

  @override
  State<AuthMiddleware> createState() => _AuthMiddlewareState();
}

class _AuthMiddlewareState extends State<AuthMiddleware> {
  Widget _buildAuthMiddleware(
      BuildContext context, AuthStateProvider authProvider) {
    return StreamBuilder<bool>(
      stream: authProvider.authStateStream,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        // Show a loading screen while waiting for the auth state to load
        if (!snapshot.hasData) {
          print(">>> Auth middleware: On loading...");
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
          // }
        }

        // if (snapshot.hasError) {
        //   Navigator.pop(context);
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => LoginPage(),
        //       ));

        //   return const Center();
        // }

        // Redirect based on the latest auth state

        bool isAuthenticated = snapshot.data ?? false;
        print(">>> Auth middleware: Done. Is auth: ${isAuthenticated}");
        return isAuthenticated ? widget.onAuthChild : LoginPage();
      },
    );
  }

  Widget _buildAuthMiddlewarev2(BuildContext context) {
    return Consumer<AuthStateProvider>(
      builder: (context, value, child) {
        // bool isAuthenticated = (value.currentUser!=null && !value.currentUser!.isEmpty());
        print(">>> Auth middleware: Done. Is auth: ${value.isAuthorized}");
        // return value.isAuthorized ? widget.onAuthChild : widget.unAuthChild;
        return value.isAuthorized
            //  FutureBuilder(
            //   future: Future.value(value.isAuthorized),
            //   builder: (context, snapshot) {
            //     return snapshot.connectionState == ConnectionState.waiting
            //         ? Scaffold(
            //             body: Center(
            //               child: CircularProgressIndicator(),
            //             ),
            //           )
            //         : snapshot.data!
            ? widget.onAuthChild
            : const LoginPage();
        // : widget.unAuthChild;
        // },
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthStateProvider>(context, listen: false);

    return _buildAuthMiddleware(context, authProvider);
    // return _buildAuthMiddlewarev2(context);
  }
}
