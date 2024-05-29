import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:notebook_progress/welcome_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 100).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    Future.delayed(Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WelcomeScreen(recommendedCamps: [])),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF64C8C8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomPaint(
              painter: CirclePainter(_controller.value),
              child: SizedBox(
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 30),
            Text('LOADING...', style: TextStyle(color: Colors.white, letterSpacing: 3,fontFamily: 'Concert One')),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: _animation.value / 100,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;

  CirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;
    int count = 12;
    double step = 2 * math.pi / count;

    for (int i = 0; i < count; i++) {
      double opacity = (1 - (i / count + progress) % 1).clamp(0.1, 1);
      paint.color = Colors.white.withOpacity(opacity);
      double x = radius + radius * math.cos(step * i) - 5;
      double y = radius + radius * math.sin(step * i) - 5;
      canvas.drawCircle(Offset(x, y), 5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
