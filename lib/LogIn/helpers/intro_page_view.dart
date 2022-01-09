import 'package:flutter/material.dart';

import '../SignUp/SignUpPage.dart';
import '../SignUp/walkthrough.dart';
import 'intro_page_item.dart';
import 'page_transformer.dart';

class IntroPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: SizedBox.fromSize(
                  size: const Size.fromHeight(530.0),
                  child: PageTransformer(
                    pageViewBuilder: (context, visibilityResolver) {
                      return PageView.builder(
                        controller: PageController(viewportFraction: 0.85),
                        itemCount: sampleItems.length,
                        itemBuilder: (context, index) {
                          final item = sampleItems[index];
                          final pageVisibility =
                              visibilityResolver.resolvePageVisibility(index);

                          return IntroPageItem(
                            item: item,
                            pageVisibility: pageVisibility,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(
                        builder: (BuildContext context) => SignUpPage()));
                  },
                  child: Text(
                    'Tap Here To Sign Up',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
