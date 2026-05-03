// lib/presentation/screens/video_recuerdo_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';

class VideoRecuerdoScreen extends StatefulWidget {
  final List<String> fotosPaths;
  const VideoRecuerdoScreen({super.key, required this.fotosPaths});

  @override
  State<VideoRecuerdoScreen> createState() => _VideoRecuerdoScreenState();
}

class _VideoRecuerdoScreenState extends State<VideoRecuerdoScreen> {
  final ImagePicker _picker = ImagePicker();

  bool _videoGrabado = false;
  String? _videoPath;

  @override
  void initState() {
    super.initState();
    // Abrir la cámara DIRECTAMENTE al entrar a la pantalla
    _grabarVideo();
  }

  Future<void> _grabarVideo() async {
    try {
      // Abrir la cámara nativa del celular para grabar video
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (video != null) {
        setState(() {
          _videoGrabado = true;
          _videoPath = video.path;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video grabado correctamente')),
        );
      } else {
        // Si el usuario cancela la grabación, volver atrás
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _reproducirVideo() {
    if (_videoPath != null) {
      OpenFile.open(_videoPath);
    }
  }

  void _regrabar() {
    setState(() {
      _videoGrabado = false;
      _videoPath = null;
    });
    _grabarVideo();
  }

  void _guardarRecuerdo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Recuerdo guardado!'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📷 3 fotos del objeto'),
            Text('💾 Formato: VIDEO'),
            Text('🎥 Video guardado correctamente'),
            SizedBox(height: 16),
            Text('El recuerdo quedó oculto en tu objeto.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context); // Volver a captura emocional
              Navigator.pop(context); // Volver a guardar recuerdo
              Navigator.pop(context); // Volver al feed
            },
            child: const Text('VOLVER AL INICIO'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Si ya se grabó el video, mostrar pantalla de revisión
    if (_videoGrabado) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('VIDEO RECUERDO'),
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
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                'Video grabado correctamente',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Ubicación: $_videoPath',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _reproducirVideo,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('REPRODUCIR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _regrabar,
                    icon: const Icon(Icons.replay),
                    label: const Text('REGRABAR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _guardarRecuerdo,
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'GUARDAR RECUERDO',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Mientras graba, mostrar un loading simple
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Abriendo cámara...'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // No necesitamos reiniciar aquí porque usamos ImagePicker (cámara nativa)
    // Pero aseguramos que no haya conflictos
    super.dispose();
  }
}
