
import 'dart:io';
import 'dart:typed_data';
import 'package:crud_yt_basic/calificacion_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';


class ExamenPantalla extends StatefulWidget {
  final List<Map<String, dynamic>> contenido; // Lista de contenido para el examen

  const ExamenPantalla({super.key, required this.contenido});

  @override
  State<ExamenPantalla> createState() => _ExamenPantallaState();
}

class _ExamenPantallaState extends State<ExamenPantalla> {
  VideoPlayerController? _videoPlayerController;
  final _respuestaController = TextEditingController();
  bool _isCorrect = false;
  bool _isChecked = false;
  int _correctas = 0;  // Contador de respuestas correctas
  int _indiceActual = 0;  // Índice del video actual

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    Uint8List videoBytes = widget.contenido[_indiceActual]['video'];
    final videoFile = await _writeToFile(videoBytes);

    if (videoFile != null) {
      _videoPlayerController = VideoPlayerController.file(videoFile);
      await _videoPlayerController!.initialize();
      setState(() {});
      _videoPlayerController!.setLooping(true); // Para hacer loop al video
      _videoPlayerController!.play(); // Inicia la reproducción automática
    }
  }

  Future<File?> _writeToFile(Uint8List? data) async {
    if (data == null) return null;
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/temp_video_exam_${_indiceActual}.mp4');
    return file.writeAsBytes(data);
  }

  void _corregir() {
    String respuesta = _respuestaController.text.trim();
    String significadoCorrecto = widget.contenido[_indiceActual]['significado'].trim();

    setState(() {
      _isCorrect = respuesta.toLowerCase() == significadoCorrecto.toLowerCase();
      _isChecked = true;
      if (_isCorrect) _correctas++;  // Incrementa si la respuesta es correcta
    });
  }

  void _siguienteVideo() {
    setState(() {
      _isChecked = false;
      _respuestaController.clear();
      _indiceActual++;  // Pasa al siguiente video
      if (_indiceActual < widget.contenido.length) {
        _initializeVideo();  // Carga el siguiente video
      }
    });
  }

  void _verCalificacion() {
    // Navega a una nueva pantalla para mostrar la calificación
    int totalVideos = widget.contenido.length;
    double calificacion = (_correctas / totalVideos) * 100;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalificacionPantalla(calificacion: calificacion),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _respuestaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Examen de Contenido'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _videoPlayerController != null && _videoPlayerController!.value.isInitialized
                  ? SizedBox(
                      width: 250, // Ancho específico del video
                      height: 400, // Alto específico del video
                      child: VideoPlayer(_videoPlayerController!),
                    )
                  : const CircularProgressIndicator(),
              const SizedBox(height: 20),
              TextField(
                controller: _respuestaController,
                decoration: const InputDecoration(
                  labelText: 'Escribe el significado del video',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _corregir,
                child: const Text('Corregir'),
              ),
              const SizedBox(height: 20),
              if (_isChecked)
                Text(
                  _isCorrect
                      ? '¡Correcto! Obtuviste una calificación perfecta.'
                      : 'Incorrecto. El significado correcto era: "${widget.contenido[_indiceActual]['significado']}".',
                  style: TextStyle(
                    fontSize: 18,
                    color: _isCorrect ? Colors.green : Colors.red,
                  ),
                ),
              const SizedBox(height: 20),
              if (_isChecked && _indiceActual < widget.contenido.length - 1)
                ElevatedButton(
                  onPressed: _siguienteVideo,
                  child: const Text('Siguiente Video'),
                ),
              if (_isChecked && _indiceActual == widget.contenido.length - 1)
                ElevatedButton(
                  onPressed: _verCalificacion,
                  child: const Text('Ver Calificación'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}



