import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:ybt_app/result_screen.dart'; // Sonuç ekranı için

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
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  int _score = 0;
  Color _backgroundColor = Colors.blue;
  String? _correctAnswer;
  int _remainingTime = 20;
  bool _canAnswer = false; // İlk başta yanıt verilemez.
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _questionsFuture = loadQuestions();
    startTimer();
  }

  Future<List<Question>> loadQuestions() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final List<dynamic> data = json.decode(response);

    List<Question> questions = data
        .where((item) => item['soruTuru'] == widget.soruTuru)
        .map((item) => Question.fromJson(item))
        .toList();

    questions.shuffle(Random());
    return questions.take(20).toList(); // İlk 20 soruyu seç
  }

  void checkAnswer(Question question, {bool isTimeUp = false}) {
    if (_selectedAnswer != null || isTimeUp) {
      setState(() {
        _canAnswer =
            false; // Yanıt verildiğinde tıklamaları devre dışı bırakıyoruz.
        _correctAnswer = question.cevaplar[int.parse(question.dogruCevap) - 1];
        if (_selectedAnswer == _correctAnswer) {
          _score += 10;
          _backgroundColor = Colors.green;
        } else {
          _backgroundColor = isTimeUp ? Colors.orange : Colors.red;
        }
      });

      // Doğru cevabı göstermeden önce bir süre bekliyoruz
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _backgroundColor = Colors.blue;
            _selectedAnswer = null; // Seçilen cevabı sıfırlıyoruz.
          });

          // Doğru cevabı göstermek için
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _currentQuestionIndex++; // Sonraki soruya geçiyoruz.
                _correctAnswer = null; // Doğru cevabı sıfırlıyoruz.
                _canAnswer =
                    true; // Yeni soruya geçince tıklamaya izin veriyoruz.
              });
              if (_currentQuestionIndex >= _questions.length) {
                saveScore();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultScreen(
                          score: _score,
                          userName: widget.userName,
                          kategori: widget.soruTuru)),
                );
              } else {
                resetTimer();
              }
            }
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

    scoreList.add({
      "name": widget.userName,
      "score": _score,
      "category": widget.soruTuru == "1" ? "Genel Kültür" : "Bilişim"
    });

    await file.writeAsString(json.encode(scoreList));
  }

  void startTimer() {
    setState(() {
      _remainingTime = 20;
      _canAnswer = false; // İlk başta yanıt verilemez.
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _canAnswer = true; // 5 saniye sonra soruya yanıt verilebilir.
        });
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _remainingTime--;
        });
      }
      if (_remainingTime == 0) {
        _timer.cancel();
        checkAnswer(_questions[_currentQuestionIndex],
            isTimeUp: true); // Süre bitince otomatik geçiş
      }
    });
  }

  void resetTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.soruTuru == "1" ? "Genel Kültür" : "Bilişim"} Soruları'),
      ),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Hiç soru bulunamadı.'));
          }

          _questions = snapshot.data!;
          if (_currentQuestionIndex >= _questions.length) {
            return Container(); // Sorular bitince boş ekran (ResultScreen'e yönlenecek)
          }

          final question = _questions[_currentQuestionIndex];

          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: _backgroundColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Soru ${_currentQuestionIndex + 1}: ${question.soru}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Kalan Süre: $_remainingTime',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAnswerButton(question.cevaplar[0], question),
                          const SizedBox(width: 16),
                          _buildAnswerButton(question.cevaplar[1], question),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAnswerButton(question.cevaplar[2], question),
                          const SizedBox(width: 16),
                          _buildAnswerButton(question.cevaplar[3], question),
                        ],
                      ),
                    ],
                  ),
                  if (_correctAnswer != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Doğru Cevap: $_correctAnswer',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnswerButton(String cevap, Question question) {
    bool isCorrectAnswer =
        cevap == question.cevaplar[int.parse(question.dogruCevap) - 1];
    bool isSelectedAnswer = _selectedAnswer == cevap;

    Color buttonColor;
    if (isSelectedAnswer) {
      buttonColor = isCorrectAnswer ? Colors.green : Colors.red;
    } else if (isCorrectAnswer && _correctAnswer != null) {
      buttonColor = Colors.yellow;
    } else {
      buttonColor = Colors.teal[100]!;
    }

    return ElevatedButton(
      onPressed: _canAnswer
          ? () {
              setState(() {
                _selectedAnswer = cevap;
              });
              checkAnswer(question);
            }
          : null, // Yanıt verildikten sonra buton devre dışı
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: const Size(200, 150),
      ),
      child: Text(
        cevap,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class Question {
  final String soru;
  final List<String> cevaplar;
  final String dogruCevap;
  final String soruTuru;

  Question({
    required this.soru,
    required this.cevaplar,
    required this.dogruCevap,
    required this.soruTuru,
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
      soruTuru: json['soruTuru'],
    );
  }
}
