// lib/services/video_recorder_service.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class VideoRecorderService {
  CameraController? _controller;
  bool _isRecording = false;

  void setController(CameraController controller) {
    _controller = controller;
  }

  Future<String> startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Cámara no inicializada');
    }
    
    if (_isRecording) {
      throw Exception('Ya está grabando');
    }
    
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final String filePath = path.join(appDir.path, fileName);
      
      await _controller!.startVideoRecording();
      _isRecording = true;
      
      return filePath;
    } catch (e) {
      throw Exception('Error al iniciar grabación: $e');
    }
  }

  Future<String> stopRecording() async {
    if (_controller == null || !_isRecording) {
      throw Exception('No hay grabación activa');
    }
    
    try {
      final XFile videoFile = await _controller!.stopVideoRecording();
      _isRecording = false;
      
      // Mover a la carpeta de documentos
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final String finalPath = path.join(appDir.path, fileName);
      
      await File(videoFile.path).copy(finalPath);
      
      return finalPath;
    } catch (e) {
      _isRecording = false;
      throw Exception('Error al detener grabación: $e');
    }
  }

  bool get isRecording => _isRecording;
}