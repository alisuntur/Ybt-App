import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SorularScreen extends StatefulWidget {
  final String soruTuru;

  const SorularScreen({super.key, required this.soruTuru});

  @override
  _SorularScreenState createState() => _SorularScreenState();
}

class _SorularScreenState extends State<SorularScreen> {
  late Future<List<Question>> _questions;
  int _currentQuestionIndex = 0; // Geçerli soru indeksini tutar.
  String? _selectedAnswer; // Seçilen cevabı tutar.

  @override
  void initState() {
    super.initState();
    _questions = loadQuestions();
  }

  Future<List<Question>> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final List<dynamic> data = json.decode(response);

    // Soru türüne göre filtreleme
    return data
        .where((item) => item['soruTuru'] == widget.soruTuru)
        .map((item) => Question.fromJson(item))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.soruTuru == "1" ? "Genel Kültür" : "Bilişim"} Soruları'),
      ),
      body: FutureBuilder<List<Question>>(
        future: _questions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Hiç soru bulunamadı.'));
          }

          final questions = snapshot.data!;

          // Eğer geçerli soru indeksi toplam sorulardan büyükse, sonuçları göster
          if (_currentQuestionIndex >= questions.length) {
            return const Center(child: Text('Tüm sorular cevaplandı!'));
          }

          final question = questions[_currentQuestionIndex];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  question.soru,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              ...question.cevaplar.map((cevap) {
                return RadioListTile<String>(
                  title: Text(cevap),
                  value: cevap,
                  groupValue: _selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswer = value;
                    });
                  },
                );
              }),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_selectedAnswer != null) {
                      // Seçilen cevap kontrolü yapabilirsin
                      // Doğru cevabı kontrol et
                      if (_selectedAnswer ==
                          question
                              .cevaplar[int.parse(question.dogruCevap) - 1]) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Doğru cevap!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Yanlış cevap!')),
                        );
                      }
                      _currentQuestionIndex++;
                      _selectedAnswer = null; // Seçimi sıfırla
                    }
                  });
                },
                child: Text(_currentQuestionIndex < questions.length - 1
                    ? 'Sonraki Soru'
                    : 'Bitir'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Question {
  final String soru;
  final List<String> cevaplar;
  final String dogruCevap;

  Question({
    required this.soru,
    required this.cevaplar,
    required this.dogruCevap,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      soru: json['soru'],
      cevaplar: [
        json['cevap1'],
        json['cevap2'],
        json['cevap3'],
        json['cevap4'],
      ],
      dogruCevap: json['dogruCevap'],
    );
  }
}
