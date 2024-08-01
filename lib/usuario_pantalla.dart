import 'package:crud_yt_basic/db_helper.dart';
import 'package:flutter/material.dart';

class UsuarioPantalla extends StatefulWidget {
  const UsuarioPantalla({super.key});

  @override
  State<UsuarioPantalla> createState() => _UsuarioPantallaState();
}

class _UsuarioPantallaState extends State<UsuarioPantalla> {

  List<Map<String, dynamic>> _allUsuario = [];
  bool _isLoading = true;

  void _refreshUsuario() async {
    final usuario = await SQLHelper.getAllUsuario();
    setState(() {
      _allUsuario = usuario;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshUsuario();
  }

  Future<void> _addUsuario() async {
    await SQLHelper.crearUsuario(
      username.text, 
      nombre.text, 
      apellido.text, 
      correo.text, 
      password.text, 
      fechaNacimiento.text, 
      perfil.text
    );
    _refreshUsuario();
  }  

  Future<void> _updateUsuario(int id) async {
    await SQLHelper.updateUsuario(
      id, 
      nombre.text, 
      apellido.text, 
      correo.text, 
      password.text, 
      fechaNacimiento.text, 
      perfil.text
    );
    _refreshUsuario();
  }

  //DELETE USUARIO
  void _deleteUsuario(int id) async {
    await SQLHelper.deleteUsuario(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text('Usuario eliminado'),
      )
    );
    _refreshUsuario();
  }

  final username = TextEditingController();
  final nombre = TextEditingController();
  final apellido = TextEditingController();
  final correo = TextEditingController();
  final password = TextEditingController();
  final fechaNacimiento = TextEditingController();
  final perfil = TextEditingController();

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingUsuario = 
      _allUsuario.firstWhere((element) => element['idUsuario'] == id);
      username.text = existingUsuario['name_usuario'];
      nombre.text = existingUsuario['nombre'];
      apellido.text = existingUsuario['apellido'];
      correo.text = existingUsuario['correo'];
      password.text = existingUsuario['password'];
      fechaNacimiento.text = existingUsuario['fecha_nacimiento'];
      perfil.text = existingUsuario['perfil'];
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
              controller: username,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nombre de usuario'
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: nombre,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nombre'
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: apellido,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Apellido'
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: correo,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Correo electrónico'
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: password,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Contraseña'
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: fechaNacimiento,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Fecha de nacimiento Ej: aaaa-mm-dd'
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: perfil,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Perfil: estudiante/administrador'
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addUsuario();
                  }
                  if (id != null) {
                    await _updateUsuario(id);
                  }
                  nombre.text = '';
                  apellido.text = ''; 
                  correo.text = ''; 
                  password.text = ''; 
                  fechaNacimiento.text = ''; 
                  perfil.text = '';
                  //Ocultar bottom sheet
                  Navigator.of(context).pop();
                }, 
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    id == null ? 'Añadir Usuario' : 'Actualizar Usuario',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )
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
        title: const Text('Usuarios'),
      ),
      body: _isLoading
            ? const Center(
              child: Text('Tabla vacía'),
            )
            : ListView.builder(
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(_allUsuario[index]['name_usuario'], style: const TextStyle(fontSize: 20)),
                  ),
                  subtitle: Column(
                    children: [
                      Text(_allUsuario[index]['nombre'], style: const TextStyle(fontSize: 20)),
                      Text(_allUsuario[index]['apellido'], style: const TextStyle(fontSize: 20)),
                      Text(_allUsuario[index]['correo'], style: const TextStyle(fontSize: 20)),
                      Text(_allUsuario[index]['password'], style: const TextStyle(fontSize: 20)),
                      Text(_allUsuario[index]['fecha_nacimiento'], style: const TextStyle(fontSize: 20)),
                      Text(_allUsuario[index]['perfil'], style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showBottomSheet(_allUsuario[index]['idUsuario']);
                        }, 
                        icon: const Icon( Icons.edit, color: Colors.indigo)
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteUsuario(_allUsuario[index]['idUsuario']);
                        }, 
                        icon: const Icon( Icons.delete, color: Colors.redAccent)
                      ),
                    ],
                  ),
                ),
              ),
              itemCount: _allUsuario.length
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => showBottomSheet(null),
              child: const Icon(Icons.add),
            ),
    );
  }
}