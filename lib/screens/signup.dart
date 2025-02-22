import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/component/wide_button.dart';
import 'package:locker_management/screens/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _mobileEditingController =
      TextEditingController();
  String? gender;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
            _isLoading
                ? ProgressBar()
                : Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/icons/applogo.png',
                        height: MediaQuery.of(context).size.height * 0.28,
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
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 15, 8, 8),
                                      child: Text(
                                        'Muslim Child App',
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
                                    'Name',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: _nameEditingController,
                                  keyboardType: TextInputType.name,
                                  style: const TextStyle(fontSize: 18),
                                  cursorColor: Colors.black54,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 0,
                                    ),
                                    hintText: 'Enter your name',
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
                                    'Mobile Number',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: _mobileEditingController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 18),
                                  cursorColor: Colors.black54,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 0,
                                    ),
                                    hintText: 'Enter your mobile number',
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
                                    'Gender',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // create a checkbox list for male or female
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Male',
                                      groupValue: gender,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Male',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Radio<String>(
                                      value: 'Female',
                                      groupValue: gender,
                                      onChanged: (value) {
                                        setState(() {
                                          gender = value;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Female',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
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
                                const SizedBox(height: 20),
                                WideButton(
                                  'Sign Up',
                                  onPressed: () async {
                                    if (_nameEditingController.text
                                        .trim()
                                        .isEmpty) {
                                      Fluttertoast.showToast(
                                        msg: 'Enter your name',
                                      );
                                    } else if (_mobileEditingController.text
                                        .trim()
                                        .isEmpty) {
                                      Fluttertoast.showToast(
                                        msg: 'Please enter your mobile number',
                                      );
                                    } else if (gender == null) {
                                      Fluttertoast.showToast(
                                        msg: 'Please select your gender',
                                      );
                                    } else {
                                      setState(() {
                                        // _isLoading = true;
                                      });
                                    }
                                  },
                                  backgroundcolor:
                                      Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                ),
                                SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Already have an account? ',
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
                                                    (context) => const Login(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Login',
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
                                ),
                              ],
                            ),
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
