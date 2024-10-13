import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'; // Dosya işlemleri için
import 'dart:io';
import 'dart:math';

class SorularScreen extends StatefulWidget {
  final String soruTuru;
  final String userName; // Kullanıcı adı

  const SorularScreen(
      {super.key, required this.soruTuru, required this.userName});

  @override
  _SorularScreenState createState() => _SorularScreenState();
}

class _SorularScreenState extends State<SorularScreen> {
  late Future<List<Question>> _questionsFuture;
  List<Question> _questions = []; // Tüm soruları tutacak liste
  int _currentQuestionIndex = 0; // Geçerli soru indeksi
  String? _selectedAnswer; // Seçilen cevabı tutar
  int _score = 0; // Toplam puanı tutar
  Color _backgroundColor = Colors.blue; // Arka plan rengi
  String? _correctAnswer; // Doğru cevabı tutar

  @override
  void initState() {
    super.initState();
    _questionsFuture = loadQuestions();
  }

  Future<List<Question>> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final List<dynamic> data = json.decode(response);

    // Sadece seçilen soru türüne göre filtrele
    List<Question> questions = data
        .where((item) => item['soruTuru'] == widget.soruTuru)
        .map((item) => Question.fromJson(item))
        .toList();

    // Soruları rastgele karıştır
    questions.shuffle(Random());

    return questions;
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
            _backgroundColor = Colors.blue; // Arka plan rengini sıfırla
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.soruTuru == "1" ? "Genel Kültür" : "Bilişim"} Soruları'),
      ),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture, // Future'ı burada kullanıyoruz
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Hiç soru bulunamadı.'));
          }

          // Burada snapshot.data ile sorulara erişiyoruz
          _questions = snapshot.data!;

          if (_currentQuestionIndex >= _questions.length) {
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

          final question = _questions[_currentQuestionIndex];

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
                      'Soru ${_currentQuestionIndex + 1}: ${question.soru}', // İndeksi burada göster
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAnswerButton(question.cevaplar[0], question),
                          const SizedBox(
                              width: 16), // İki buton arasında boşluk
                          _buildAnswerButton(question.cevaplar[1], question),
                        ],
                      ),
                      const SizedBox(height: 16), // Satırlar arası boşluk
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAnswerButton(question.cevaplar[2], question),
                          const SizedBox(
                              width: 16), // İki buton arasında boşluk
                          _buildAnswerButton(question.cevaplar[3], question),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Cevap butonunu oluşturan fonksiyon
  Widget _buildAnswerButton(String cevap, Question question) {
    bool isCorrectAnswer =
        cevap == question.cevaplar[int.parse(question.dogruCevap) - 1];
    bool isSelectedAnswer = _selectedAnswer == cevap;

    // Buton rengini ayarlama
    Color buttonColor;
    if (isSelectedAnswer) {
      buttonColor = isCorrectAnswer
          ? Colors.green
          : Colors.red; // Doğru cevap yeşil, yanlış cevap kırmızı
    } else if (isCorrectAnswer && _correctAnswer != null) {
      buttonColor = Colors.yellow; // Doğru cevap, ama seçilmediğinde sarı
    } else {
      buttonColor = Colors.teal[100]!; // Normal durum
    }

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedAnswer = cevap;
        });
        checkAnswer(question); // Cevabı kontrol et
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: const Size(200, 150), // Buton boyutu
      ),
      child: Text(
        cevap,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
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
