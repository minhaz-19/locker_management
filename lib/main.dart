import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locker_management/provider/userDetailsProvider.dart';
import 'package:locker_management/screens/home.dart';
import 'package:locker_management/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(MyApp(email: email));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.email});
  final String? email;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(
          0,
          36,
          22,
          1.0,
        ), // You can set any color here
        statusBarIconBrightness:
            Brightness.light, // Change the status bar icons' color
      ),
    );
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserDetailsProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(0, 36, 22, 1.0),

          appBarTheme: const AppBarTheme(color: Color.fromRGBO(0, 36, 22, 1.0)),
          // use backgroung color for the whole app using colorscheme
          // scaffoldBackgroundColor: Color.fromARGB(255, 93, 151, 128),
        ),
        home: AnimatedSplashScreen(
          backgroundColor: Color.fromARGB(255, 65, 122, 99),
          duration: 1500,
          splash: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/applogo.png",
                      height: 400,
                      width: 400,
                    ),
                  ],
                ),
              ),
            ),
          ),
          nextScreen: Login(fromStart: true),
          splashIconSize: 550,
          splashTransition: SplashTransition.scaleTransition,
        ),
      ),
    );
  }
}
