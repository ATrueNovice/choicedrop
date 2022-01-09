import 'dart:async';

import 'package:choicedrop/Static/static.dart';
import 'package:flutter/material.dart';

class SplashPageScreen extends StatefulWidget {
  @override
  SplashPageScreenState createState() => SplashPageScreenState();
}

class SplashPageScreenState extends State<SplashPageScreen> {
  @override
  void initState() {
    _nextPage();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          width: screenAwareSize(250, context),
          child: Image.asset(
            'assets/cdLogo.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  void _nextPage() {
    Future.delayed(
        const Duration(
          seconds: 2,
        ), () {
      Navigator.pushReplacementNamed(context, '/landingscreen');
    });
  }
}
