import 'package:crud_yt_basic/db_helper.dart';
import 'package:crud_yt_basic/leccion_pantalla.dart';
import 'package:flutter/material.dart';

class NivelPantalla extends StatefulWidget {

  

  const NivelPantalla({super.key});

  @override
  State<NivelPantalla> createState() => _NivelPantallaState();
}

class _NivelPantallaState extends State<NivelPantalla> {

  List<Map<String, dynamic>> _allNivel = [];
  bool _isLoading = true;

  void _refreshNivel() async {
    final nivel = await SQLHelper.getAllNivel();
    setState(() {
      _allNivel = nivel;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshNivel();
  }

  Future<void> _addNivel() async{
    await SQLHelper.crearNivel(
      _tituloController.text, 
      _descripcionController.text
    );
    _refreshNivel();
  }

  Future<void> _updateNivel(int id) async {
    await SQLHelper.updateNivel(id, _tituloController.text, _descripcionController.text);
    _refreshNivel();
  }

  //DELETE NIVEL
  void _deleteNivel(int id) async {
    await SQLHelper.deleteNivel(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Nivel eliminado')
      )
    );
    _refreshNivel();
  }

  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingNivel =
      _allNivel.firstWhere((element) => element['idNivel'] == id);
      _tituloController.text = existingNivel['titulo'];
      _descripcionController.text = existingNivel['descripcion'];
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
                hintText: 'Título de Nivel'
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _descripcionController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descripción de Nivel'
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addNivel();
                  }
                  if (id != null) {
                    await _updateNivel(id);
                  }
                  _tituloController.text = '';
                  _descripcionController.text = '';
                  //Ocultar botton sheet
                  Navigator.of(context).pop();
                }, 
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    id == null ? 'Añadir Nivel' : 'Actualizar Nivel',
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
        title: const Text('Niveles'),
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
                    child: Text(_allNivel[index]['titulo'], style: const TextStyle(fontSize: 20)),
                  ),
                  subtitle: Text(_allNivel[index]['descripcion'], style: const TextStyle(fontSize: 20)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showBottomSheet(_allNivel[index]['idNivel']);
                        }, 
                        icon: const Icon(Icons.edit, color: Colors.indigo)
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteNivel(_allNivel[index]['idNivel']);
                        }, 
                        icon: const Icon(Icons.delete, color: Colors.redAccent)
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LeccionPantalla()), // Asegúrate de reemplazar LoginScreen con el nombre de tu pantalla de login
                    );
                  },
                ),
              ), 
              separatorBuilder: (context, index) => const Divider(), 
              itemCount: _allNivel.length
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => showBottomSheet(null),
              child: const Icon(Icons.add),
            ),
    );
  }
}