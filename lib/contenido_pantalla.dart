import 'dart:io';
import 'dart:typed_data';
import 'package:crud_yt_basic/db_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class ContenidoPantalla extends StatefulWidget {
  const ContenidoPantalla({super.key});

  @override
  State<ContenidoPantalla> createState() => _ContenidoPantallaState();
}

class _ContenidoPantallaState extends State<ContenidoPantalla> {
  List<Map<String, dynamic>> _allContenido = [];
  bool _isLoading = true;

  VideoPlayerController? _videoController;
  Uint8List? _videoData;

  final _significadoController = TextEditingController();

  void _refreshContenido() async {
    final contenido = await SQLHelper.getAllContenido();
    setState(() {
      _allContenido = contenido;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshContenido();
  }

  Future<void> _addContenido() async {
    if (_videoData != null) {
      await SQLHelper.crearContenido(
        _videoData!,
        _significadoController.text,
      );
      _refreshContenido();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Por favor, selecciona un video'),
        ),
      );
    }
  }

  Future<void> _updateContenido(int id) async {
    if (_videoData != null) {
      await SQLHelper.updateContenido(
        id,
        _videoData!,
        _significadoController.text,
      );
      _refreshContenido();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Por favor, selecciona un video'),
        ),
      );
    }
  }

  void _deleteContenido(int id) async {
    await SQLHelper.deleteContenido(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Contenido eliminado'),
      ),
    );
    _refreshContenido();
  }

  Future<File?> _writeToFile(Uint8List? data) async {
    if (data == null) return null;
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/temp_video.mp4');
    return file.writeAsBytes(data);
  }

  Future<void> _pickVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.video);
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _videoData = result.files.single.bytes!;
        });
        final videoFile = await _writeToFile(_videoData);
        if (videoFile != null) {
          setState(() {
            _videoController = VideoPlayerController.file(videoFile)
              ..initialize().then((_) {
                setState(() {});
              });
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Error al seleccionar el video'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Error: $e'),
        ),
      );
    }
  }

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingContenido =
          _allContenido.firstWhere((element) => element['idContenido'] == id);
      _significadoController.text = existingContenido['significado'];
      _videoData = existingContenido['video'];
      final videoFile = await _writeToFile(_videoData);
      setState(() {
        if (videoFile != null) {
          _videoController = VideoPlayerController.file(videoFile)
            ..initialize().then((_) {
              setState(() {});
            });
        }
      });
    } else {
      _significadoController.text = '';
      _videoData = null;
      _videoController = null;
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            padding: EdgeInsets.only(
              top: 30,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final result = await FilePicker.platform.pickFiles(type: FileType.video);
                      if (result != null && result.files.single.bytes != null) {
                        setModalState(() {
                          _videoData = result.files.single.bytes!;
                        });
                        final videoFile = await _writeToFile(_videoData);
                        if (videoFile != null) {
                          setModalState(() {
                            _videoController = VideoPlayerController.file(videoFile)
                              ..initialize().then((_) {
                                setModalState(() {});
                              });
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text('Error al seleccionar el video'),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('Error: $e'),
                        ),
                      );
                    }
                  },
                  child: const Text('Seleccionar Video'),
                ),
                const SizedBox(height: 5),
                _videoController != null && _videoController!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      )
                    : const Text('No hay video seleccionado'),
                const SizedBox(height: 5),
                TextField(
                  controller: _significadoController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Significado del contenido',
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addContenido();
                      } else {
                        await _updateContenido(id);
                      }
                      _significadoController.text = '';
                      _videoData = null;
                      _videoController = null;
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Text(
                        id == null ? 'Añadir Contenido' : 'Actualizar Contenido',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 191, 191),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Contenido'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(_allContenido[index]['significado'],
                        style: const TextStyle(fontSize: 20)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showBottomSheet(_allContenido[index]['idContenido']);
                        },
                        icon: const Icon(Icons.edit, color: Colors.indigo),
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteContenido(_allContenido[index]['idContenido']);
                        },
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: _allContenido.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBottomSheet(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
