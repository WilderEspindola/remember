// lib/main.dart
import 'package:flutter/material.dart';
import 'presentation/screens/feed_screen.dart';
import 'services/camera_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar cámara EN BACKGROUND mientras carga la app
  final cameraService = CameraService();
  await cameraService.preinitialize();
  
  runApp(const RememberApp());
}

class RememberApp extends StatelessWidget {
  const RememberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remember',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FeedScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}