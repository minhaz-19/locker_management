import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/component/shared_preference.dart';
import 'package:locker_management/component/wide_button.dart';
import 'package:locker_management/screens/home.dart';
import 'package:locker_management/screens/signup.dart';

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

  void initializeLogin() async {
    setState(() {
      _isLoading = true;
    });
    final email = await getDataFromDevice('email') ?? "";
    final password = await getDataFromDevice('password') ?? "";
    if (email != "") {}

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 15, 8, 8),
                                    child: Text(
                                      'Locker Management',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 8, 8),
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(fontSize: 18),
                                cursorColor: Colors.black54,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 0,
                                  ),
                                  hintText: 'Enter your email',
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                  ),
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
                                onSaved: (newValue) {
                                  setState(() {
                                    // Handle the value if needed
                                  });
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 15, 8, 8),
                                child: Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                style: const TextStyle(fontSize: 18),
                                cursorColor: Colors.black54,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 0,
                                  ),
                                  hintText: 'Enter your password',
                                  hintStyle: const TextStyle(
                                    color: Colors.black54,
                                  ),
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
                                onSaved: (newValue) {
                                  setState(() {
                                    // Handle the value if needed
                                  });
                                },
                              ),
                              InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const RecoverPassword()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    15,
                                    8,
                                    8,
                                  ),
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              WideButton(
                                'Login',
                                onPressed: () async {
                                  setState(() {
                                    // _isLoading = true;
                                  });
                                },
                                backgroundcolor: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Don\'t have an account? ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
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
                    // Align the last widget to the center bottom
                  ],
                ),
      ),
    );
  }
}
