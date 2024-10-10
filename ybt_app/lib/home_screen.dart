import 'package:flutter/material.dart';
import 'question_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ekran genişliğini ve yüksekliğini MediaQuery ile alıyoruz
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          child: SingleChildScrollView(
            // Taşmayı önlemek için
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Placeholder
                CircleAvatar(
                  radius: screenWidth * 0.15, // Dinamik boyutlandırma
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
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.07,
                            vertical: screenHeight * 0.03),
                        child: const Text(
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
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.07,
                            vertical: screenHeight * 0.03),
                        child: const Text(
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
                        backgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.07,
                            vertical: screenHeight * 0.03),
                        child: const Text(
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
      ),
    );
  }
}
