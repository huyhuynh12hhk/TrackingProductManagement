// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tracking_app_v1/models/responseTypes/login_user.dart';
// import 'package:tracking_app_v1/pages/auth/login_page.dart';
// import 'package:tracking_app_v1/pages/common/home_page.dart';
// import 'package:tracking_app_v1/pages/common/not_found.dart';
// import 'package:tracking_app_v1/providers/auth_state_provider.dart';

// class AuthMiddleware extends StatelessWidget {
//   const AuthMiddleware({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final auth = context.watch<AuthenticationProvider>();
//     // final authState = Provider.of<AuthStateProvider>(context, listen: false);
//     return Consumer<AuthStateProvider>(
//       builder: (context, authState, _) {
//         return FutureBuilder(
//             future: authState.checkAuthState(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Scaffold(
//                     body: const Center(child: CircularProgressIndicator()));
//               }
//               print("On change: now user login = ${authState.isAuthorized}");
//               return authState.isAuthorized == true
//                   ? const HomePage()
//                   : const LoginPage();
//             });

          
//     }
//     );
//   }
// }
