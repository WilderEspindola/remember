// lib/presentation/screens/lista_recuerdos_screen.dart
import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../data/models/memory_model.dart';

class ListaRecuerdosScreen extends StatefulWidget {
  const ListaRecuerdosScreen({super.key});

  @override
  State<ListaRecuerdosScreen> createState() => _ListaRecuerdosScreenState();
}

class _ListaRecuerdosScreenState extends State<ListaRecuerdosScreen> {
  List<MemoryModel> _recuerdos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarRecuerdos();
  }

  Future<void> _cargarRecuerdos() async {
    setState(() {
      _isLoading = true;
    });
    
    final recuerdos = await DatabaseService().getAllMemories();
    
    setState(() {
      _recuerdos = recuerdos;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MIS RECUERDOS'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarRecuerdos,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recuerdos.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No hay recuerdos guardados',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Guarda tu primer recuerdo',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _recuerdos.length,
                  itemBuilder: (context, index) {
                    final recuerdo = _recuerdos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: _getIconForType(recuerdo.tipoRecuerdo),
                        title: Text(
                          'Recuerdo ${recuerdo.tipoRecuerdo.toUpperCase()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${recuerdo.id.substring(0, 8)}...'),
                            Text('Creado: ${_formatDate(recuerdo.createdAt)}'),
                            if (recuerdo.tipoRecuerdo == 'texto')
                              Text('Texto: "${recuerdo.textoExtra}"'),
                          ],
                        ),
                        trailing: Text(
                          '${recuerdo.vecesEncontrado} veces',
                          style: const TextStyle(fontSize: 12),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
    );
  }

  Icon _getIconForType(String tipo) {
    switch (tipo) {
      case 'video':
        return const Icon(Icons.videocam, color: Colors.red);
      case 'texto':
        return const Icon(Icons.edit_note, color: Colors.blue);
      case 'foto':
        return const Icon(Icons.camera_alt, color: Colors.green);
      default:
        return const Icon(Icons.help);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}