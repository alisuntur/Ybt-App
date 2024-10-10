import 'package:flutter/material.dart';

class SorularScreen extends StatefulWidget {
  const SorularScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SorularScreenState createState() => _SorularScreenState();
}

class _SorularScreenState extends State<SorularScreen> {
  String soruMetni =
      "Hangi gezegen Güneş Sistemi'ndeki en büyük gezegendir?"; // Burada sorular yer alacak
  String cevap1 = "Mars";
  String cevap2 = "Venüs";
  String cevap3 = "Jüpiter";
  String cevap4 = "Dünya";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Soru Ekranı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pop(context); // Ana ekrana geri döner
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Süre Geri Sayımı (Placeholder)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Süre Geri Sayım: 30 saniye',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                // Soru Metni
                Container(
                  padding: const EdgeInsets.all(50.0),
                  margin: const EdgeInsets.all(50.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    soruMetni,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Cevap Butonları (2x2 grid layout)
                SizedBox(
                  width:
                      screenWidth * 0.8, // Grid genişliği ekran boyutuna göre
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Cevap 1
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Cevap 1'e tıklandığında yapılacak işlem
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.03,
                                ),
                              ),
                              child: Text(cevap1),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Cevap 2
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Cevap 2'ye tıklandığında yapılacak işlem
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.03,
                                ),
                              ),
                              child: Text(cevap2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Cevap 3
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Cevap 3'e tıklandığında yapılacak işlem
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.03,
                                ),
                              ),
                              child: Text(cevap3),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Cevap 4
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Cevap 4'e tıklandığında yapılacak işlem
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.03,
                                ),
                              ),
                              child: Text(cevap4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Logo
                CircleAvatar(
                  radius: screenWidth * 0.05, // Dinamik logo boyutu
                  backgroundColor: Colors.grey[300],
                  backgroundImage: const AssetImage('assets/logo.png'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
