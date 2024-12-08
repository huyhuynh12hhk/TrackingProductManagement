

import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Page Not Found",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text("Click here to back home",
                style: TextStyle(
                  color: Colors.blue[400],
                  fontSize: 15,
                  decoration: TextDecoration.underline
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}