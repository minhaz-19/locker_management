import 'package:flutter/material.dart';

class AllLocker extends StatefulWidget {
  const AllLocker({super.key});

  @override
  State<AllLocker> createState() => _AllLockerState();
}

class _AllLockerState extends State<AllLocker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('All Locker Tab'),
      ),
    );
  }
}