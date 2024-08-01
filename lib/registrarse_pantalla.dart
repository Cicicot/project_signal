import 'package:crud_yt_basic/db_helper.dart';
import 'package:crud_yt_basic/login_pantalla.dart';
import 'package:flutter/material.dart';

class RegistrarsePantalla extends StatefulWidget {
  const RegistrarsePantalla({super.key});

  @override
  State<RegistrarsePantalla> createState() => _RegistrarsePantallaState();
}

class _RegistrarsePantallaState extends State<RegistrarsePantalla> {

  final username = TextEditingController();
  final nombre = TextEditingController();
  final apellido = TextEditingController();
  final correo = TextEditingController();
  final password = TextEditingController();
  final fechaNacimiento = TextEditingController();
  final perfil = TextEditingController();

  final formKey = GlobalKey();

  Future<void> _addUsuario() async {
    await SQLHelper.crearUsuario(
      username.text, 
      nombre.text, 
      apellido.text, 
      correo.text, 
      password.text, 
      fechaNacimiento.text, 
      perfil.text = 'estudiante'
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPantalla()), // Asegúrate de reemplazar LoginScreen con el nombre de tu pantalla de login
    );
    // _refreshUsuario();
  } 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro', style: TextStyle(color: Colors.purple[800], fontWeight: FontWeight.w800),),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Campo usuario
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 152, 103, 243).withOpacity(.3)
                ),
                child: TextFormField(
                  controller: username,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo usuario obligatorio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon( Icons.person ),
                    border: InputBorder.none,
                    hintText: 'Usuario'
                  ),
                ),
              ),
              //Campo nombre
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 152, 103, 243).withOpacity(.3)
                ),
                child: TextFormField(
                  controller: nombre,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo nombre obligatorio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon( Icons.arrow_right_alt_sharp ),
                    border: InputBorder.none,
                    hintText: 'Nombre'
                  ),
                ),
              ),
              //Campo apellido
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 152, 103, 243).withOpacity(.3)
                ),
                child: TextFormField(
                  controller: apellido,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo apellido obligatorio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon( Icons.arrow_right_alt_sharp ),
                    border: InputBorder.none,
                    hintText: 'Apellido'
                  ),
                ),
              ),
              //Campo correo
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 152, 103, 243).withOpacity(.3)
                ),
                child: TextFormField(
                  controller: correo,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo correo electrónico obligatorio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon( Icons.email ),
                    border: InputBorder.none,
                    hintText: 'Correo electrónico'
                  ),
                ),
              ),
              //Campo Contraseña
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 152, 103, 243).withOpacity(.3)
                ),
                child: TextFormField(
                  controller: password,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo contraseña obligatorio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon( Icons.lock ),
                    border: InputBorder.none,
                    hintText: 'Contraseña'
                  ),
                ),
              ),
              //Campo fecha de nacimiento
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 152, 103, 243).withOpacity(.3)
                ),
                child: TextFormField(
                  controller: fechaNacimiento,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Campo fecha de nacimiento obligatorio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon( Icons.date_range ),
                    border: InputBorder.none,
                    hintText: 'Fecha de nacimiento: aaaa/mm/dd'
                  ),
                ),
              ),
              //REGISTRARSE
                  Container(
                    height: 65,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration( 
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.purple[800]
                      ),
                    child: TextButton(
                      onPressed: _addUsuario, 
                      child: const Text('REGISTRARSE', style: TextStyle(fontSize: 20, color: Colors.white))
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}