// lib/presentation/screens/captura_emocional_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'texto_recuerdo_screen.dart';
import 'video_recuerdo_screen.dart';
import 'foto_recuerdo_screen.dart';

class CapturaEmocionalScreen extends StatelessWidget {
  final List<String> fotosPaths;
  const CapturaEmocionalScreen({super.key, required this.fotosPaths});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿CÓMO GUARDAS ESTO?'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Sección de imágenes
            Column(
              children: [
                // Imagen CENTRAL (FRENTE) - más pequeña
                Column(
                  children: [
                    const Text(
                      'FRENTE',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(fotosPaths[0])),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(color: Colors.purple, width: 1.5),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Dos imágenes debajo: IZQUIERDA y DERECHA
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'IZQUIERDA',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(File(fotosPaths[1])),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'DERECHA',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(File(fotosPaths[2])),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Sección de botones de formato (más pequeños)
            Column(
              children: [
                const Text(
                  'Elige el formato',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    _buildFormatButton(
                      icon: Icons.videocam,
                      label: 'VIDEO',
                      color: Colors.red,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoRecuerdoScreen(
                              fotosPaths: fotosPaths,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildFormatButton(
                      icon: Icons.edit_note,
                      label: 'TEXTO',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TextoRecuerdoScreen(
                              fotosPaths: fotosPaths,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildFormatButton(
                      icon: Icons.camera_alt,
                      label: 'FOTO',
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FotoRecuerdoScreen(
                              fotosPaths: fotosPaths,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}