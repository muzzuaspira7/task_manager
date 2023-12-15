import 'package:flutter/material.dart';
import 'MyHomeScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Delayed navigation to MyHomeScreen after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyHomeScreen(),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFF002D5C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.list,
            //   color: Colors.white38,
            //   size: 40,
            // ),

            Image.asset(
              'assets/images/task-logo.png',
              scale: 5,
            ),

            SizedBox(
              height: 20,
            ),
            Text(
              'Task Manager',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
