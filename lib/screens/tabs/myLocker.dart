import 'package:flutter/material.dart';

class MyLocker extends StatefulWidget {
  const MyLocker({super.key});

  @override
  State<MyLocker> createState() => _MyLockerState();
}

class _MyLockerState extends State<MyLocker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('My Locker'),
      ),
    );
  }
}