import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  final int id;
  final String text;
  final String choice0;
  final String choice1;
  final double progress;

  const CardView({
    Key? key,
    required this.id,
    required this.text,
    required this.choice0,
    required this.choice1,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade400,
              Colors.purple.shade900,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                text,
                style: const TextStyle(fontSize: 24, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32.0, bottom: 32.0),
                      child: Text(
                        choice0,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 32.0, top: 32.0),
                      child: Text(
                        choice1,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  CustomPaint(
                    painter: DiagonalDividerPainter(),
                    size: Size(
                      MediaQuery.of(context).size.width * 0.8,
                      MediaQuery.of(context).size.height * 0.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagonalDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 1.0;

    canvas.drawLine(
        const Offset(10, 10), Offset(size.width - 10, size.height - 10), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
