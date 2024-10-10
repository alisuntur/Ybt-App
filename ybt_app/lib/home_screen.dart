import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'question_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name; // Kullanıcı ismini saklamak için bir değişken

  @override
  void initState() {
    super.initState();
    // Ekran yüklendiğinde kullanıcıdan isim almak için dialog aç
    Future.delayed(Duration.zero, () {
      _showNameInputDialog(context);
    });
  }

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
                // Hoş geldin metni
                Text(
                  name != null
                      ? '$name, BİLGİ YARIŞMASINA HOŞGELDİN'
                      : 'BİLGİ YARIŞMASINA HOŞGELDİN',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Button Row (Genel Kültür, Bilişim, Puan Listesi)
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Genel Kültür Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SorularScreen(
                                soruTuru: "1"), // Genel Kültür
                          ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SorularScreen(soruTuru: "2"), // Bilişim
                          ),
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
                          'Bilişim',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Puan Listesi Button
                    ElevatedButton(
                      onPressed: () {
                        _showScoreListDialog(context);
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
                          'Puan Listesi',
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

  // Kullanıcıdan isim almak için dialog
  void _showNameInputDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('İsminizi Girin'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'İsminizi girin'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Gönder'),
              onPressed: () {
                String enteredName = controller.text;
                if (enteredName.isNotEmpty) {
                  setState(() {
                    name = enteredName; // Kullanıcı ismini sakla
                  });
                  Navigator.of(context).pop(); // Dialogu kapat
                  if (kDebugMode) {
                    print('Kullanıcı İsmi: $enteredName'); // Debug için
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Puan listesini gösteren dialog
  void _showScoreListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Puan Listesi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(name ?? 'Henüz isim girilmedi.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Kapat'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
