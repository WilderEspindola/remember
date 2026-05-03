// lib/presentation/screens/foto_recuerdo_screen.dart
import 'package:flutter/material.dart';

class FotoRecuerdoScreen extends StatelessWidget {
  final List<String> fotosPaths;
  const FotoRecuerdoScreen({super.key, required this.fotosPaths});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FOTO RECUERDO'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Tomar foto adicional',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text('Próximamente...'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Próximamente')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('TOMAR FOTO'),
            ),
          ],
        ),
      ),
    );
  }
}