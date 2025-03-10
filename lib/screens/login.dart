import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/component/shared_preference.dart';
import 'package:locker_management/component/wide_button.dart';
import 'package:locker_management/provider/userDetailsProvider.dart';
import 'package:locker_management/screens/home.dart';
import 'package:locker_management/screens/signup.dart';
import 'package:locker_management/screens/user_home.dart';
import 'package:path_provider/path_provider.dart';

class Login extends StatefulWidget {
  final bool fromStart;
  const Login({super.key, this.fromStart = false});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    initializeLogin();
    super.initState();
  }

  Future<void> signIn(email, password) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await ApiResponse().signIn(email, password);
      if (response.statusCode == 200) {
        await saveDataToDevice('email', email);
        await saveDataToDevice('password', password);
        await saveDataToDevice('token', response.data['token']);
        UserDetailsProvider().updateToken(response.data['token']);
        UserDetailsProvider().updateId(response.data['userId']);
        UserDetailsProvider().updateRole(response.data['roles']);
        await ApiResponse().updateToken(UserDetailsProvider.firebaseToken);
        if (response.data['roles'] == "ADMIN") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserHome()),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getFirebaseToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await saveDataToDevice('firebaseToken', token);
      UserDetailsProvider().updateFirebaseToken(token);
    }
  }

  void initializeLogin() async {
    setState(() {
      _isLoading = true;
    });
    await getFirebaseToken();
    final email = await getDataFromDevice('email') ?? "";
    final password = await getDataFromDevice('password') ?? "";
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await signIn(email, password);
      } catch (e) {
        removeDataFromDevice('email');
        removeDataFromDevice('password');
        setState(() {
          _isLoading = false;
        });
      }
    }
    // call api to update user details
    // and send to the next screen accordingly as user or admin

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green[200],
        body:
            _isLoading
                ? const ProgressBar()
                : Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/icons/applogo.png',
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: MediaQuery.of(context).size.height * 0.28,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextField(
                                  'Email',
                                  _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                _buildTextField(
                                  'Password',
                                  _passwordController,
                                  obscureText: true,
                                ),

                                const SizedBox(height: 20),
                                WideButton(
                                  'Login',
                                  onPressed: () async {
                                    // navigate to home page
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => const Home(),
                                    //   ),
                                    // );
                                    // setState(() {
                                    //   // Handle login action
                                    // });
                                    await signIn(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                  },
                                  backgroundcolor:
                                      Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Don't have an account? ",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => const SignUp(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink[400],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 18),
            cursorColor: Colors.black54,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              hintText: 'Enter your $label',
              hintStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: Colors.green[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(191, 153, 245, 1),
                  width: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
