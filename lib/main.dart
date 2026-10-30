import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const KacakPanoApp());
}

class KacakPanoApp extends StatelessWidget {
  const KacakPanoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaçak Pano Tespit',
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
      ),
      home: const PanoAnaSayfa(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PanoAnaSayfa extends StatefulWidget {
  const PanoAnaSayfa({super.key});

  @override
  State<PanoAnaSayfa> createState() => _PanoAnaSayfaState();
}

class _PanoAnaSayfaState extends State<PanoAnaSayfa> {
  File? _secilenDosya;
  final ImagePicker _picker = ImagePicker();
  bool _analizEdiliyor = false;
  String _sonucMesaji = "Henüz analiz yapılmadı.";
  bool _kacakVar = false;

  Future<void> _resimSec veFotoCek(ImageSource kaynak) async {
    final XFile? image = await _picker.pickImage(source: kaynak, imageQuality: 80);
    if (image != null) {
      setState(() {
        _secilenDosya = File(image.path);
        _analizEdiliyor = true;
        _sonucMesaji = "Yapay zeka panoyu inceliyor...";
        _kacakVar = false;
      });

      // Simüle edilmiş AI analiz gecikmesi (Sunucu bağlantısı simülasyonu)
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _analizEdiliyor = false;
        // Örnek simülasyon sonucu
        _kacakVar = true; 
        _sonucMesaji = "⚠️ KRİTİK: Kaçak Jumper / Müdahale Tespit Edildi! (%94.2 Güven)";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kacak Pano Denetim Sistemi'),
        backgroundColor: Colors.red[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        strutStyle: const StrutStyle(forceStrutHeight: true),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent, width: 2),
                ),
                child: _secilenDosya == null
                    ? const Center(
                        child: Text(
                          'Pano Fotoğrafı Seçilmedi\nKamera veya Galeriyi Kullanın',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_secilenDosya!, fit: BoxFit.cover),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _kacakVar ? Colors.red[900]?.withOpacity(0.3) : Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _analizEdiliyor
                      const CircularProgressIndicator(color: Colors.redAccent)
                      : Text(
                          _sonucMesaji,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _kacakVar ? Colors.redAccent : Colors.greenAccent,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _resimSecveFotoCek(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Kamera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[800],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _resimSecveFotoCek(ImageSource.gallery),
                    icon: const Icon(Icons.image),
                    label: const Text('Galeri'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
