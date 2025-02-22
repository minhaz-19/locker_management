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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  String? _selectedRole = 'Student';

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
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTextField(
                                  'Name',
                                  'Enter your name',
                                  _nameController,
                                  TextInputType.name,
                                ),
                                _buildTextField(
                                  'Mobile',
                                  'Enter your mobile number',
                                  _mobileController,
                                  TextInputType.phone,
                                ),
                                _buildTextField(
                                  'Email',
                                  'Enter your email',
                                  _emailController,
                                  TextInputType.emailAddress,
                                ),
                                _buildTextField(
                                  'Password',
                                  'Enter your password',
                                  _passwordController,
                                  TextInputType.visiblePassword,
                                  obscureText: true,
                                ),
                                _buildTextField(
                                  'Status',
                                  'Enter your status',
                                  _statusController,
                                  TextInputType.text,
                                ),

                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 15, 8, 8),
                                  child: Text(
                                    'Role',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  value: _selectedRole,
                                  items:
                                      ['Student', 'Teacher', 'Visitor'].map((
                                        role,
                                      ) {
                                        return DropdownMenuItem(
                                          value: role,
                                          child: Text(role),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRole = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    filled: true,
                                    fillColor: Colors.green[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                WideButton(
                                  'Sign Up',
                                  onPressed: () async {
                                    if (_nameController.text.trim().isEmpty) {
                                      Fluttertoast.showToast(
                                        msg: 'Enter your name',
                                      );
                                    } else if (_mobileController.text
                                        .trim()
                                        .isEmpty) {
                                      Fluttertoast.showToast(
                                        msg: 'Please enter your mobile number',
                                      );
                                    } else if (_selectedRole == null) {
                                      Fluttertoast.showToast(
                                        msg: 'Please select your role',
                                      );
                                    } else {
                                      setState(() {
                                        _isLoading = true;
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
                  ],
                ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    TextInputType type, {
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: controller,
            keyboardType: type,
            obscureText: obscureText,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              hintText: hint,
              filled: true,
              fillColor: Colors.green[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
