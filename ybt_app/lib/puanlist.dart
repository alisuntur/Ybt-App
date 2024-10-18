import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PuanList extends StatefulWidget {
  const PuanList({super.key});

  @override
  _PuanListState createState() => _PuanListState();
}

class _PuanListState extends State<PuanList>
    with SingleTickerProviderStateMixin {
  List<dynamic> puanlar = [];
  String hataMesaji = ''; // Hata mesajını saklamak için bir değişken
  late TabController _tabController; // Tab controller

  @override
  void initState() {
    super.initState();
    _loadPuanlar(); // Uygulama açılır açılmaz puanları yükle
    _tabController = TabController(length: 3, vsync: this); // 3 sekme için
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

  // Puanları kategoriye göre filtreleme
  List<dynamic> _filterByCategory(String kategori) {
    if (kategori == 'Hepsi') {
      return puanlar;
    } else {
      return puanlar.where((puan) => puan['category'] == kategori).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puan Listesi'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Hepsi'),
            Tab(text: 'Genel Kültür'),
            Tab(text: 'Bilişim'),
          ],
        ),
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
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPuanList('Hepsi'),
                    _buildPuanList('Genel Kültür'),
                    _buildPuanList('Bilişim'),
                  ],
                )
              : const Center(
                  child: Text('Henüz puan kaydı yok!'),
                ),
    );
  }

  // Puan listesini oluşturan fonksiyon
  Widget _buildPuanList(String kategori) {
    final filteredPuanlar = _filterByCategory(kategori);

    if (filteredPuanlar.isEmpty) {
      return const Center(child: Text('Bu kategoride puan bulunamadı!'));
    }

    return ListView.builder(
      itemCount: filteredPuanlar.length,
      itemBuilder: (context, index) {
        final puanItem = filteredPuanlar[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title:
              Text(puanItem['name'] ?? 'İsim Yok'), // "name" anahtarını kullan
          subtitle: Text(
              'Puan: ${puanItem['score'] ?? 0} - Kategori: ${puanItem['category'] ?? "Kategori Yok"}'), // "score" ve "category" anahtarını kullan
        );
      },
    );
  }
}
