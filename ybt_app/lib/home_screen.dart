import 'package:flutter/material.dart';
import 'package:ybt_app/question_screen.dart';
import 'puanlist.dart'; // Puan listesi için yeni sayfa

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Kullanıcı ismini saklamak için bir değişken
  String userName = '';

  // Kullanıcıdan isim almak için bir dialog açan fonksiyon
  void _showUserNameDialog(String soruTuru) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('İsim Giriniz'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "İsminizi girin"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Kaydet'),
              onPressed: () {
                setState(() {
                  userName = controller.text; // Kullanıcı ismini güncelle
                });
                Navigator.of(context).pop();
                // Sorular ekranına yönlendir
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SorularScreen(
                      soruTuru: soruTuru,
                      userName: userName,
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapat
              },
            ),
          ],
        );
      },
    );
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
                // Button Row (Genel Kültür, Bilişim, Puan Listesi)
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Genel Kültür Button
                    ElevatedButton(
                      onPressed: () {
                        _showUserNameDialog("1"); // Genel Kültür için dialog aç
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
                        _showUserNameDialog("2"); // Bilişim için dialog aç
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PuanList(), // PuanList ekranına git
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
}
