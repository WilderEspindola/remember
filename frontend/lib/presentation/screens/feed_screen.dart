// lib/presentation/screens/feed_screen.dart
import 'package:flutter/material.dart';
import 'guardar_recuerdo_screen.dart';
import 'reencuentro_screen.dart'; // ← NUEVA IMPORTACIÓN
import 'lista_recuerdos_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'REMEMBER',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón 1: Guardar Recuerdo
            _buildButton(
              icon: Icons.camera_alt,
              label: 'GUARDAR RECUERDO',
              color: Colors.purple,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GuardarRecuerdoScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            // Botón 2: Reencuentro
            _buildButton(
              icon: Icons.search,
              label: 'REENCUENTRO',
              color: Colors.deepPurple,
              onPressed: () {
                // NAVEGAR a la pantalla de Reencuentro
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReencuentroScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            // Botón temporal para ver recuerdos guardados
            _buildButton(
              icon: Icons.list,
              label: 'VER RECUERDOS',
              color: Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListaRecuerdosScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 4,
      ),
    );
  }
}
