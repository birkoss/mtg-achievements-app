import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home.dart';
import './screens/login.dart';
import './screens/register.dart';
import './screens/splash.dart';

import './providers/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("MyApp.build");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => UserProvider(),
        )
      ],
      child: Consumer<UserProvider>(
        builder: (context, user, _) => MaterialApp(
          title: 'MTG Achievements',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: TextTheme(
              headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
          ),
          home: user.isLogged
              ? HomeScreen()
              : FutureBuilder(
                  future: user.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    print("FutureBuilder.builder...");
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SplashScreen();
                    } else {
                      print("icitte?");
                      return LoginScreen();
                    }
                  }),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            RegisterScreen.routeName: (ctx) => RegisterScreen(),
          },
        ),
      ),
    );
  }
}
