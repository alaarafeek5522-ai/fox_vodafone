import 'package:flutter/material.dart';

class TopWaveDesign extends StatelessWidget {
  const TopWaveDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF8B0000),
              Color(0xFFC62828),
              Color(0xFFE53935),
              Color(0xFFDC143C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomPaint(
          painter: WavePainter(),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.8);
    
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.9,
      size.width * 0.5, size.height * 0.8,
    );
    
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.7,
      size.width, size.height * 0.85,
    );
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final path = Path();
      path.moveTo(0, size.height * (0.3 + i * 0.15));
      
      path.quadraticBezierTo(
        size.width * 0.3, size.height * (0.2 + i * 0.1),
        size.width * 0.6, size.height * (0.3 + i * 0.15),
      );
      
      path.quadraticBezierTo(
        size.width * 0.8, size.height * (0.35 + i * 0.1),
        size.width, size.height * (0.25 + i * 0.12),
      );
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
