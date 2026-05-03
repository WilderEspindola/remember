// lib/services/camera_service.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitializing = false;
  bool _isInitialized = false;
  int _currentCameraIndex = 0;

  Future<void> preinitialize() async {
    if (_isInitialized || _isInitializing) return;
    
    _isInitializing = true;
    try {
      _cameras = await availableCameras();
      _controller = CameraController(
        _cameras![_currentCameraIndex],
        ResolutionPreset.medium,
      );
      await _controller!.initialize();
      _isInitialized = true;
    } catch (e) {
      print('Error inicializando cámara: $e');
    } finally {
      _isInitializing = false;
    }
  }

  // NUEVO MÉTODO: Reiniciar la cámara para un nuevo uso
  Future<void> reset() async {
    try {
      if (_controller != null) {
        await _controller!.dispose();
        _controller = null;
      }
      _isInitialized = false;
      await preinitialize();
    } catch (e) {
      print('Error reiniciando cámara: $e');
    }
  }

  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    
    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;
    
    final oldController = _controller;
    _controller = CameraController(
      _cameras![_currentCameraIndex],
      ResolutionPreset.medium,
    );
    
    try {
      await _controller!.initialize();
      await oldController?.dispose();
      _isInitialized = true;
    } catch (e) {
      _controller = oldController;
      rethrow;
    }
  }

  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;

  Future<String> takePicture() async {
    if (!_isInitialized) throw Exception('Cámara no inicializada');
    
    final XFile picture = await _controller!.takePicture();
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String filePath = path.join(appDir.path, fileName);
    
    await File(picture.path).copy(filePath);
    return filePath;
  }

  void dispose() {
    _controller?.dispose();
    _isInitialized = false;
  }
}