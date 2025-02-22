import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, this.color = Colors.white});
  final  color;

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      color: this.color,
    );
  }
}
