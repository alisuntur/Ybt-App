import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'; // Dosya işlemleri için
import 'dart:io';

class SorularScreen extends StatefulWidget {
  final String soruTuru;
  final String userName; // Kullanıcı adı

  const SorularScreen(
      {super.key, required this.soruTuru, required this.userName});

  @override
  _SorularScreenState createState() => _SorularScreenState();
}

class _SorularScreenState extends State<SorularScreen> {
  late Future<List<Question>> _questions;
  int _currentQuestionIndex = 0; // Geçerli soru indeksi
  String? _selectedAnswer; // Seçilen cevabı tutar
  int _score = 0; // Toplam puanı tutar
  Color _backgroundColor = Colors.white; // Arka plan rengi
  String? _correctAnswer; // Doğru cevabı tutar

  @override
  void initState() {
    super.initState();
    _questions = loadQuestions();
  }

  Future<List<Question>> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final List<dynamic> data = json.decode(response);

    return data
        .where((item) => item['soruTuru'] == widget.soruTuru)
        .map((item) => Question.fromJson(item))
        .toList();
  }

  void checkAnswer(Question question) {
    if (_selectedAnswer != null) {
      setState(() {
        _correctAnswer = question
            .cevaplar[int.parse(question.dogruCevap) - 1]; // Doğru cevabı al
        if (_selectedAnswer == _correctAnswer) {
          _score += 10; // Doğru cevaba 10 puan ekle
          _backgroundColor = Colors.green; // Doğru cevaba yeşil
        } else {
          _backgroundColor = Colors.red; // Yanlış cevaba kırmızı
        }
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _backgroundColor = Colors.white; // Arka plan rengini sıfırla
            _currentQuestionIndex++;
            _selectedAnswer = null;
            _correctAnswer = null; // Doğru cevabı sıfırla
          });
        }
      });
    }
  }

  Future<void> saveScore() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/puan.json';
    final file = File(filePath);

    List<dynamic> scoreList = [];

    if (await file.exists()) {
      String contents = await file.readAsString();
      scoreList = json.decode(contents);
    }

    // Kullanıcı ismini ve puanı kaydet
    scoreList.add({"name": widget.userName, "score": _score});

    await file.writeAsString(json.encode(scoreList));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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

          if (_currentQuestionIndex >= questions.length) {
            saveScore(); // Puanı kaydet
            return Center(
              child: Text(
                'Tüm sorular cevaplandı!\nHoşgeldin ${widget.userName}!\nToplam Puanınız: $_score',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          }

          final question = questions[_currentQuestionIndex];

          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: _backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Column(
                    children: question.cevaplar.map((cevap) {
                      // Doğru cevabı belirle
                      bool isCorrectAnswer = cevap ==
                          question.cevaplar[int.parse(question.dogruCevap) - 1];
                      bool isSelectedAnswer = _selectedAnswer == cevap;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SizedBox(
                          width: screenWidth * 0.9,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedAnswer = cevap;
                              });
                              checkAnswer(question); // Cevabı kontrol et
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelectedAnswer
                                  ? (isCorrectAnswer
                                      ? Colors.green // Doğru seçenek
                                      : Colors.red) // Yanlış seçilen seçenek
                                  : (isCorrectAnswer && _selectedAnswer != null
                                      ? Colors
                                          .yellow // Yanlış seçilen seçenek varsa doğru seçenek sarı
                                      : Colors.grey), // Seçenek seçilmedi
                            ),
                            child: Text(
                              cevap,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
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
