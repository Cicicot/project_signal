import 'package:crud_yt_basic/contenido_pantalla.dart';
import 'package:crud_yt_basic/db_helper.dart';
import 'package:flutter/material.dart';

class LeccionPantalla extends StatefulWidget {
  const LeccionPantalla({super.key});

  @override
  State<LeccionPantalla> createState() => _LeccionPantallaState();
}

class _LeccionPantallaState extends State<LeccionPantalla> {

  List<Map<String, dynamic>> _allLeccion = [];
  bool _isLoading = true;

  void _refreshLeccion() async {
    final leccion = await SQLHelper.getAllLeccion();
    setState(() {
      _allLeccion = leccion;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshLeccion();
  }

  Future<void> _addLeccion() async{
    await SQLHelper.crearLeccion(
      _tituloController.text, 
      _descripcionController.text
    );
    _refreshLeccion();
  }

  Future<void> _updateLeccion(int id) async {
    await SQLHelper.updateLeccion(
      id, 
      _tituloController.text, 
      _descripcionController.text);
    _refreshLeccion();
  }

  //DELETE LECCIÓN
  void _deleteLeccion(int id) async {
    await SQLHelper.deleteLeccion(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Nivel eliminado')
      )
    );
    _refreshLeccion();
  }

  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingLeccion =
      _allLeccion.firstWhere((element) => element['idLeccion'] == id);
      _tituloController.text = existingLeccion['titulo'];
      _descripcionController.text = existingLeccion['descripcion'];
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Título de Leccion'
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _descripcionController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descripción de Leccion'
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addLeccion();
                  }
                  if (id != null) {
                    await _updateLeccion(id);
                  }
                  _tituloController.text = '';
                  _descripcionController.text = '';
                  //Ocultar botton sheet
                  Navigator.of(context).pop();
                }, 
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    id == null ? 'Añadir Leccion' : 'Actualizar Leccion',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 191, 191),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Leccion'),
      ),
      body: _isLoading
            ? const Center(
              child: Text('Tabla vacía'),
            )
            : ListView.separated(
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(_allLeccion[index]['titulo'], style: const TextStyle(fontSize: 20)),
                  ),
                  subtitle: Text(_allLeccion[index]['descripcion'], style: const TextStyle(fontSize: 20)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showBottomSheet(_allLeccion[index]['idLeccion']);
                        }, 
                        icon: const Icon(Icons.edit, color: Colors.indigo)
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteLeccion(_allLeccion[index]['idLeccion']);
                        }, 
                        icon: const Icon(Icons.delete, color: Colors.redAccent)
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const ContenidoPantalla()), // Asegúrate de reemplazar LoginScreen con el nombre de tu pantalla de login
                    );
                  },
                ),
              ), 
              separatorBuilder: (context, index) => const Divider(), 
              itemCount: _allLeccion.length
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => showBottomSheet(null),
              child: const Icon(Icons.add),
            ),
    );
  }
}