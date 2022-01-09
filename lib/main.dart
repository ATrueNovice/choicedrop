import 'package:choicedrop/APIS/google_sign_in.dart';
import 'package:choicedrop/BottomBar/bottombar.dart';
import 'package:choicedrop/Checkout/CartProvider.dart';
import 'package:choicedrop/LogIn/SplashPage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'LogIn/helpers/landingPage.dart';

Future main() async {
  debugPaintSizeEnabled = false;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
//dfasfasdfassdfasfe
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: CartProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.grey,
              accentColor: Colors.greenAccent,
              textTheme: TextTheme(
                headline1: TextStyle(
                    fontFamily: 'Poppins', color: Colors.blue, fontSize: 22),
                headline2: TextStyle(
                    fontFamily: 'Poppins', color: Colors.blue, fontSize: 20),
                headline3: TextStyle(
                    fontFamily: 'Poppins', color: Colors.blue, fontSize: 18),
                headline4: TextStyle(
                    fontFamily: 'Poppins', color: Colors.blue, fontSize: 16),
                headline5: TextStyle(
                    fontFamily: 'Poppins', color: Colors.blue, fontSize: 16),
                headline6: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: Colors.blue,
                    fontSize: 18),
                subtitle1: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: Colors.black,
                    fontSize: 14),
                subtitle2: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: Colors.white,
                    fontSize: 12),
                bodyText1: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: Colors.black,
                    fontSize: 14),
                bodyText2: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: Colors.blue,
                    fontSize: 16),
              )),
          darkTheme: ThemeData(
              primarySwatch: Colors.grey,
              primaryColor: Colors.white,
              brightness: Brightness.dark,
              dividerColor: Colors.black12,
              selectedRowColor: Colors.yellow,
              unselectedWidgetColor: Colors.white,
              textTheme: TextTheme(
                headline1: TextStyle(
                    fontFamily: 'Poppins', color: Colors.white, fontSize: 22),
                headline2: TextStyle(
                    fontFamily: 'Poppins', color: Colors.white, fontSize: 20),
                headline3: TextStyle(
                    fontFamily: 'Poppins', color: Colors.blue, fontSize: 18),
                headline4: TextStyle(
                    fontFamily: 'Poppins', color: Colors.white, fontSize: 16),
                headline5: TextStyle(
                    fontFamily: 'Poppins', color: Colors.blue, fontSize: 16),
                headline6: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: Colors.blue,
                    fontSize: 18),
                subtitle1: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: Colors.white,
                    fontSize: 14),
                subtitle2: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: Colors.white,
                    fontSize: 12),
                bodyText1: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: Colors.black,
                    fontSize: 14),
                bodyText2: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    color: Colors.blue,
                    fontSize: 16),
              )),
          home: const MyHomePage(),
          routes: <String, WidgetBuilder>{
            //app routes
            '/landingscreen': (BuildContext context) => LoginPage(),
          },
        ),
      ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<Object>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return BottomBarController();
              } else {
                return SplashPageScreen();
              }
            }));
  }
}
