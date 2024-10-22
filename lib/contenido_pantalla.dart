import 'dart:io';
import 'dart:typed_data';
import 'package:crud_yt_basic/db_helper.dart';
import 'package:crud_yt_basic/examen_pantalla.dart';
import 'package:crud_yt_basic/login_pantalla.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class ContenidoPantalla extends StatefulWidget {
  const ContenidoPantalla({super.key});

  @override
  State<ContenidoPantalla> createState() => _ContenidoPantallaState();
}

class _ContenidoPantallaState extends State<ContenidoPantalla> {
  List<Map<String, dynamic>> _allContenido = [];
  bool _isLoading = true;

  late VideoPlayerController _videoPlayerController;
  Uint8List? _video;

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
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse('https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4')
    );  
    _refreshContenido();
  }

  Future<void> _addContenido() async {
    if (_video != null && _significadoController.text.isNotEmpty) {
      // Llama al método crearContenido de tu helper para agregar el nuevo contenido
      await SQLHelper.crearContenido(
        _video!,  // El video en formato Uint8List
        _significadoController.text,  // El texto del significado
      );
      _refreshContenido();  // Actualiza la lista de contenido después de agregarlo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Contenido agregado correctamente'),
        ),
      );
    } else {
      // Si no se ha seleccionado un video o el campo "significado" está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Por favor, selecciona un video y añade un significado'),
        ),
      );
    }
  }

  Future<void> _updateContenido(int id) async {
    if (_video != null && _significadoController.text.isNotEmpty) {
      await SQLHelper.updateContenido(
        id,  // ID del contenido a actualizar
        _video!,  // Video como Uint8List
        _significadoController.text,  // Nuevo significado
      );
      _refreshContenido();  // Refresca la lista de contenido
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Contenido visualizado'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Por favor, selecciona un video y añade un significado'),
        ),
      );
    }
  }

  void _deleteContenido(int id) async {
    await SQLHelper.deleteContenido(id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Contenido eliminado correctamente'),
      ),
    );

    _refreshContenido(); // Actualiza la lista de contenido
  }


  Future<void> _initializeVideo(File videoFile) async {
    try {
      _videoPlayerController.dispose();
      _videoPlayerController = VideoPlayerController.file(videoFile);
      await _videoPlayerController.initialize();
      setState(() {});
      _videoPlayerController.setLooping(true);  // Permite repetición continua
      _videoPlayerController.play();
    } catch (e) {
      // print('Error durante la inicialización del video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Error al inicializar el video: $e'),
        ),
      );
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      _video = await pickedFile.readAsBytes();
      final videoFile = File(pickedFile.path);

      // Inicia el reproductor de video
      await _initializeVideo(videoFile);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('No se seleccionó ningún video'),
        ),
      );
    }
  }

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingContenido = _allContenido.firstWhere((element) => element['idContenido'] == id);
      _significadoController.text = existingContenido['significado'];
      _video = existingContenido['video'];
      final videoFile = await _writeToFile(_video);

      if (videoFile != null) {
        await _initializeVideo(videoFile);
      }
    } else {
      _significadoController.text = '';
      _video = null;
      _videoPlayerController.dispose();
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
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await _pickVideo();
                        setModalState(() {});
                      },
                      child: const Text('Seleccionar Video'),
                    ),
                    const SizedBox(height: 10),
                    if (_videoPlayerController.value.isInitialized)
                        SizedBox(
                        width: 250, // Ancho específico del video
                        height: 400, // Alto específico del video
                        child: VideoPlayer(_videoPlayerController),
                      )
                      // AspectRatio(
                      //   aspectRatio: _videoPlayerController.value.aspectRatio,
                      //   child: VideoPlayer(_videoPlayerController),
                      // )
                    else
                      const Text('No hay video seleccionado'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _significadoController,
                      decoration: const InputDecoration(
                        labelText: 'Significado',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await _addContenido();
                        } else {
                          await _updateContenido(id);
                        }
                        Navigator.of(context).pop();
                        _refreshContenido();
                      },
                      child: Text(id == null ? 'Agregar' : 'Aprendido'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<File?> _writeToFile(Uint8List? data) async {
    if (data == null) return null;
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/temp_video.mp4');
    return file.writeAsBytes(data);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 195, 195),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Contenido'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple
              ),
              child: Column(
                children: [
                  Text('Tareas' )
                ],
              )
            ),
            Column(
              children: [
                ListTile(
                  title: const  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon( Icons.account_balance ),
                      Text('Resolver Examen'),
                    ],
                  ),
                  onTap: () {
                      if (_allContenido.isNotEmpty) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ExamenPantalla(contenido: _allContenido), // Pasa toda la lista
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text('No hay contenido disponible para el examen'),
                        ),
                      );
                    }
                  },
                ),
                ListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon( Icons.logout ),
                      Text('Cerrar sesión'),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const LoginPantalla(),
                    ));
                  },
                ),
              ],
            )
          ],
        ),
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
                        icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.indigo),
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
