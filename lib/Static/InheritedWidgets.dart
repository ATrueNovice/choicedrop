import 'package:choicedrop/Static/static.dart';
import 'package:flutter/material.dart';

class BuddiesInherited {
  Future initialProductSetup(int num) async {
    // await getProducts(num);
  }

  void updatingCartFunction(bool) {
    // updatingCart = bool;
  }
}

class HLAlertWidget {
  void showPopup(context, content) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: <Widget>[
              Image.asset('assets/cdLogo.png',
                  width: screenAwareSize(60, context),
                  height: screenAwareSize(60, context),
                  fit: BoxFit.contain),
              Text(
                'Choice Drop Helper',
                // style: titleParagraphStyle,
              )
            ],
          ),
          content: content,
          actions: <Widget>[
            MaterialButton(
              child: Text(
                "Close",
                //   style: TextStyle(
                //       color: theme.textTheme.subtitle1.color,
                //       fontFamily: theme.textTheme.subtitle1.fontFamily,
                //       fontSize: theme.textTheme.bodyText2.fontSize),
              ),
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void twoButtonPopup(context, content, function) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: <Widget>[
              Image.asset('assets/cdLogo.png',
                  width: screenAwareSize(60, context),
                  height: screenAwareSize(60, context),
                  fit: BoxFit.contain),
              Text(
                'Choice Drop Helper',
              )
            ],
          ),
          content: content,
          actions: <Widget>[
            FlatButton(
              child: Text("Add"),
              onPressed: () {
                function();
              },
            ),
            FlatButton(
              child: Text("Go Back"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  single(context, content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: <Widget>[
              Image.asset('assets/smiley.png',
                  width: screenAwareSize(60, context),
                  height: screenAwareSize(60, context),
                  fit: BoxFit.contain),
              Text(
                content,
              )
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget cardWidget(widget) {
    return Container(
        child: Card(elevation: 8.0, color: Colors.white70, child: widget));
  }

  singlebuttonWidget(context, headerText, widget, func) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            title: Row(
              children: <Widget>[
                Image.asset('assets/cdLogo.png',
                    width: screenAwareSize(80, context),
                    height: screenAwareSize(80, context),
                    fit: BoxFit.contain),
                Text(
                  headerText,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            content: widget,
            actions: <Widget>[
              MaterialButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  func;

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
