// lib/presentation/screens/guardar_recuerdo_screen.dart
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../services/camera_service.dart';
import 'captura_emocional_screen.dart';

class GuardarRecuerdoScreen extends StatefulWidget {
  const GuardarRecuerdoScreen({super.key});

  @override
  State<GuardarRecuerdoScreen> createState() => _GuardarRecuerdoScreenState();
}

class _GuardarRecuerdoScreenState extends State<GuardarRecuerdoScreen> {
  final CameraService _cameraService = CameraService();
  List<String> _fotosTomadas = [];
  int _fotoActual = 1;
  String _mensajeGuia = 'Enfoca el FRENTE del objeto';

  @override
  void initState() {
    super.initState();
    _verificarCamara();
  }

  void _verificarCamara() {
    if (!_cameraService.isInitialized) {
      _cameraService.preinitialize().then((_) {
        setState(() {});
      });
    }
  }

  Future<void> _tomarFoto() async {
    if (_fotoActual > 3) return;
    
    try {
      final String fotoPath = await _cameraService.takePicture();
      setState(() {
        _fotosTomadas.add(fotoPath);
        _fotoActual++;
        
        switch (_fotoActual) {
          case 2:
            _mensajeGuia = 'Ahora el lado IZQUIERDO';
            break;
          case 3:
            _mensajeGuia = 'Ahora el lado DERECHO';
            break;
          case 4:
            _mensajeGuia = '¡Listo!';
            break;
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Foto ${_fotosTomadas.length}/3 tomada'),
          duration: const Duration(milliseconds: 600),
        ),
      );
      
      if (_fotoActual > 3) {
        _irACapturaEmocional();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al tomar la foto')),
      );
    }
  }

  void _irACapturaEmocional() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CapturaEmocionalScreen(
        fotosPaths: _fotosTomadas,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    if (!_cameraService.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Cámara ocupando TODA la pantalla
          Positioned.fill(
            child: CameraPreview(_cameraService.controller!),
          ),
          
          // Barra superior con botón X y contador
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón cancelar (X)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    ),
                  ),
                  
                  // Contador (1/3, 2/3, 3/3)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_fotoActual/3',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // Espacio invisible para balance
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
          
          // Mensaje guía
          Positioned(
            top: 110,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                _mensajeGuia,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // Indicadores circulares (progreso de 3 fotos)
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _fotosTomadas.length
                        ? Colors.green
                        : Colors.white.withOpacity(0.5),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: index < _fotosTomadas.length
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              }),
            ),
          ),
          
          // Botón de captura (círculo grande)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _fotoActual > 3 ? null : _tomarFoto,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _fotoActual > 3 ? Colors.grey : Colors.white,
                    border: Border.all(
                      color: Colors.purple,
                      width: 4,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: _fotoActual > 3 ? Colors.grey[600] : Colors.purple,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
void dispose() {
  // Reiniciar la cámara para el próximo uso
  _cameraService.reset();
  super.dispose();
}
}