import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF7A1A1),
            Color(0xFFF48C8C), 
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFC5E2BE), 
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                  child: Text(
                    '🍓',
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
              const SizedBox(height: 24),

            const Text(
              'StrawberryCheck',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,   
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Deteksi Kematangan Buah dengan CNN',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54, 
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE34234), 
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
              child: const Text(
                'Mulai',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, 
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}