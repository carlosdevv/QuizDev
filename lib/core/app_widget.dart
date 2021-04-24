import 'package:quiz_dev/pages/challenge/challenge_page.dart';
import 'package:quiz_dev/pages/home/home_page.dart';
import 'package:quiz_dev/pages/splash/splash_page.dart';

import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DevQuiz",
      home: SplashPage(),
    );
  }
}
