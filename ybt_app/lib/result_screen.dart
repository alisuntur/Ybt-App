import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final String userName;
  final String kategori;

  const ResultScreen(
      {super.key,
      required this.score,
      required this.userName,
      required this.kategori});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sonuçlar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tebrikler $userName!', style: const TextStyle(fontSize: 24)),
            Text('Kategori: ${kategori == "1" ? "Genel Kültür" : "Bilişim"}',
                style: const TextStyle(fontSize: 24)),
            Text('Toplam Puan: $score', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Ana sayfaya dönüş
              },
              child: const Text('Ana Sayfaya Dön'),
            ),
          ],
        ),
      ),
    );
  }
}
