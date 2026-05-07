import 'package:flutter/material.dart';

class SimCard3D extends StatelessWidget {
  const SimCard3D({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.08,
      child: Container(
        width: 200,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: 12, top: 25, bottom: 25,
              child: Container(
                width: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  gradient: LinearGradient(
                    colors: Colors.grey[300]!.withOpacity(0.5) == Colors.grey
                        ? [Colors.grey, Colors.grey]
                        : [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.8)],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "فكة فودافون",
                    style: TextStyle(
                      color: Color(0xFF8B0000),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Vodafone",
                        style: TextStyle(
                          color: Color(0xFFE53935),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
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
