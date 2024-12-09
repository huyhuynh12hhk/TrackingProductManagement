import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tracking_app_v1/middlewares/auth_middleware_v2.dart';
import 'package:tracking_app_v1/pages/auth/login_page.dart';
import 'package:tracking_app_v1/pages/common/home_page.dart';
import 'package:tracking_app_v1/providers/auth_provider_v2.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app_v1/providers/camera_provider.dart';
import 'package:tracking_app_v1/providers/local_storage_provider.dart';

void main() async {
  //development solution for http
  //refer: https://stackoverflow.com/questions/54285172/how-to-solve-flutter-certificate-verify-failed-error-while-performing-a-post-req

  WidgetsFlutterBinding.ensureInitialized();

  print("Start init");
  await CameraProvider.initialization();
  LocalStorage localStorage = LocalStorage.getInstance();
  localStorage.refetchData();
  // await AuthenticationProvider.initialize();

  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalStorage.getInstance()),
        ChangeNotifierProvider(create: (_) => AuthStateProvider()),
        ChangeNotifierProvider(create: (_) => CameraProvider()),
      ],
      child: MaterialApp(
        title: 'Product Tracking Management',
        debugShowCheckedModeBanner: false,
        
        home: AuthMiddleware(
          onAuthChild: HomePage(),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


// https://stackoverflow.com/questions/49695393/how-to-build-apk-create-old-version-app-in-flutter
// https://stackoverflow.com/questions/69033022/message-error-resource-androidattr-lstar-not-found?page=1&tab=scoredesc#tab-top