import 'package:flutter/material.dart';
import 'question_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Placeholder
              CircleAvatar(
                radius: 100,
                backgroundImage: const AssetImage('assets/logo.png'),
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(height: 20),
              const Text(
                'BİLGİ YARIŞMASINA HOŞGELDİN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Button Row (Genel Kültür, Bilişim, Karışık)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Genel Kültür Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SorularScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.grey[300], // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 20.0),
                      child: Text(
                        'Genel Kültür',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Bilişim Button
                  ElevatedButton(
                    onPressed: () {
                      // Bilişim sorularına yönlendirme
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.grey[300], // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 20.0),
                      child: Text(
                        'Bilişim',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Karışık Button
                  ElevatedButton(
                    onPressed: () {
                      // Karışık sorulara yönlendirme
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.grey[300], // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 20.0),
                      child: Text(
                        'Karışık',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
