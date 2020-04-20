import 'package:flutter/material.dart';

class RotatingIndicator extends StatefulWidget {
  @override
  _RotatingIndicatorState createState() => _RotatingIndicatorState();
}

class _RotatingIndicatorState extends State<RotatingIndicator>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    super.initState();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.only(bottom: 10.0),
        width: 0.3 * MediaQuery.of(context).size.width,
        height: 0.3 * MediaQuery.of(context).size.width,
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: Image.asset(
            'assets/images/loading.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
