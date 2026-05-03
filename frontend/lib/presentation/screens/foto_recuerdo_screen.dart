// lib/presentation/screens/foto_recuerdo_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';

class FotoRecuerdoScreen extends StatefulWidget {
  final List<String> fotosPaths;
  const FotoRecuerdoScreen({super.key, required this.fotosPaths});

  @override
  State<FotoRecuerdoScreen> createState() => _FotoRecuerdoScreenState();
}

class _FotoRecuerdoScreenState extends State<FotoRecuerdoScreen> {
  final ImagePicker _picker = ImagePicker();
  
  bool _fotoTomada = false;
  String? _fotoPath;

  @override
  void initState() {
    super.initState();
    // Abrir la cámara DIRECTAMENTE al entrar a la pantalla
    _tomarFoto();
  }

  Future<void> _tomarFoto() async {
    try {
      // Abrir la cámara nativa del celular para tomar foto
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      
      if (foto != null) {
        setState(() {
          _fotoTomada = true;
          _fotoPath = foto.path;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto tomada correctamente')),
        );
      } else {
        // Si el usuario cancela la toma, volver atrás
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _verFoto() {
    if (_fotoPath != null) {
      OpenFile.open(_fotoPath);
    }
  }

  void _cambiarFoto() {
    setState(() {
      _fotoTomada = false;
      _fotoPath = null;
    });
    _tomarFoto();
  }

  void _guardarRecuerdo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Recuerdo guardado!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📷 ${widget.fotosPaths.length} fotos del objeto'),
            const Text('💾 Formato: FOTO'),
            const Text('📸 Foto guardada correctamente'),
            const SizedBox(height: 16),
            const Text('El recuerdo quedó oculto en tu objeto.'),
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
    // Si ya se tomó la foto, mostrar pantalla de revisión
    if (_fotoTomada) {
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
              // Vista previa de la foto
              Container(
                height: 300,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: FileImage(File(_fotoPath!)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              const Icon(Icons.check_circle, size: 50, color: Colors.green),
              const SizedBox(height: 8),
              const Text(
                'Foto tomada correctamente',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _verFoto,
                    icon: const Icon(Icons.visibility),
                    label: const Text('VER FOTO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _cambiarFoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('CAMBIAR FOTO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

    // Mientras toma la foto, mostrar un loading simple
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
}