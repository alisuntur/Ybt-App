import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PuanList extends StatefulWidget {
  const PuanList({super.key});

  @override
  _PuanListState createState() => _PuanListState();
}

class _PuanListState extends State<PuanList> {
  List<dynamic> puanlar = [];
  String hataMesaji = ''; // Hata mesajını saklamak için bir değişken

  @override
  void initState() {
    super.initState();
    _loadPuanlar(); // Uygulama açılır açılmaz puanları yükle
  }

  // Puanları JSON dosyasından oku
  Future<void> _loadPuanlar() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/puan.json';
      final file = File(filePath);

      if (await file.exists()) {
        final contents = await file.readAsString();
        setState(() {
          puanlar = json.decode(contents); // JSON verisini listeye çevir

          // Puanları max'dan min'e sıralama
          puanlar.sort((a, b) => b['score'].compareTo(a['score']));
        });
      } else {
        setState(() {
          hataMesaji = 'Puan dosyası bulunamadı.';
        });
      }
    } catch (e) {
      setState(() {
        hataMesaji = 'Puanlar yüklenirken hata oluştu: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puan Listesi'),
        backgroundColor: Colors.blue,
      ),
      body: hataMesaji.isNotEmpty
          ? Center(
              child: Text(
                hataMesaji, // Hata mesajını ekranda göster
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          : puanlar.isNotEmpty
              ? ListView.builder(
                  itemCount: puanlar.length,
                  itemBuilder: (context, index) {
                    final puanItem = puanlar[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(puanItem['name'] ??
                          'İsim Yok'), // "name" anahtarını kullan
                      subtitle: Text(
                          'Puan: ${puanItem['score'] ?? 0}'), // "score" anahtarını kullan
                    );
                  },
                )
              : const Center(
                  child: Text('Henüz puan kaydı yok!'),
                ),
    );
  }
}
