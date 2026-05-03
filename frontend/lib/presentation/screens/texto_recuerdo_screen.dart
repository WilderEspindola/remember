// lib/presentation/screens/texto_recuerdo_screen.dart
import 'package:flutter/material.dart';

class TextoRecuerdoScreen extends StatefulWidget {
  final List<String> fotosPaths;
  const TextoRecuerdoScreen({super.key, required this.fotosPaths});

  @override
  State<TextoRecuerdoScreen> createState() => _TextoRecuerdoScreenState();
}

class _TextoRecuerdoScreenState extends State<TextoRecuerdoScreen> {
  final TextEditingController _textController = TextEditingController();
  String _texto = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEXTO DEL RECUERDO'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Escribe lo que sientes en este momento:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Ej: "Hoy me siento feliz porque..."',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (value) {
                _texto = value;
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _texto.isEmpty ? null : _guardarRecuerdo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'GUARDAR RECUERDO',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
            const Text('💾 Formato: TEXTO'),
            Text('📝 "$_texto"'),
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
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}