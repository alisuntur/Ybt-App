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
  String cevap3 = " Jüpiter";
  String cevap4 = "Dünya";

  // Burada sorular ve cevaplar veritabanından alınacak
  // Ayrıca geri sayım ve çıkış yapma butonunu ekleyeceğiz

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soru Ekranı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Çıkış yapma işlemi
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
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.all(20.0),
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
              // Cevap Butonları
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Cevap 1'e tıklandığında yapılacak işlem
                    },
                    child: Text(cevap1),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Cevap 2'ye tıklandığında yapılacak işlem
                    },
                    child: Text(cevap2),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Cevap 3'e tıklandığında yapılacak işlem
                    },
                    child: Text(cevap3),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Cevap 4'e tıklandığında yapılacak işlem
                    },
                    child: Text(cevap4),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 20),
              // Logo
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey[300],
                backgroundImage: const AssetImage('assets/logo.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
