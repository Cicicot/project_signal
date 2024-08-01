import 'package:crud_yt_basic/db_helper.dart';
import 'package:crud_yt_basic/nivel_pantalla.dart';
import 'package:crud_yt_basic/registrarse_pantalla.dart';
import 'package:flutter/material.dart';


class LoginPantalla extends StatefulWidget {
  const LoginPantalla({super.key});

  @override
  LoginPantallaState createState() => LoginPantallaState();
}

class LoginPantallaState extends State<LoginPantalla> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoginFailed = false;

  void handleLogin() async {
    var response = await SQLHelper.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (response['success']) {
      String tipo = response['tipo'];
      
      switch (tipo) {
        case 'administrador':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NivelPantalla()),
          );
          break;
        case 'estudiante':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NivelPantalla()),
          );
          break;
        default:
          setState(() {
            isLoginFailed = true;
          });
          break;
      }
    } else {
      setState(() {
        isLoginFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lenguaje de Señas - BO', style: TextStyle(color: Colors.purple[800], fontWeight: FontWeight.w800),),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'lib/assets/leng.png',
                  height: 300,
                ),
                //Campo usuario
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 152, 103, 243).withOpacity(.3)
                  ),
                  child: TextFormField(
                    controller: _usernameController,
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
                //Campo contraseña
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 152, 103, 243).withOpacity(.3)
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
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
                const SizedBox(height: 20),
                //LOGIN
                Container(
                  height: 65,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration( 
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.purple[800]
                    ),
                  child: TextButton(
                    onPressed: handleLogin, 
                    child: const Text('INICIAR SESIÓN', style: TextStyle(fontSize: 20, color: Colors.white))
                  ),
                ),
                //Si usuario es nuevo, crearse usuario
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿Eres nuevo?'),
                      TextButton(onPressed: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => const RegistrarsePantalla(),
                          )
                        );
                      }, child: const Text('REGÍSTRATE'))
                    ],
                  ),
                if (isLoginFailed)
                  const Text(
                    'Inicio de sesión fallido. Favor de revisar sus credenciales.',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
