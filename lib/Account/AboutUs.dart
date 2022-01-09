import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(
              'About Us',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'About Buddies',
                      style: TextStyle(fontSize: 26, fontFamily: 'Poppins'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Text(
                      'HSI was created with the idea that apps should be straight forward, user friendly, and the solutions to real world problems.Our number one priority is to make your everyday life better by creating apps that:Are and always will be free.Add value to your day every time you open them.Make you wonder how youve ever gone without them!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                  ),
                  Container(
                      child: Image.asset(
                    'assets/smiley.png',
                    height: 180,
                    width: 180,
                  ))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
