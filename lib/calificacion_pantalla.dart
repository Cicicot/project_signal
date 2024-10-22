// import 'dart:io';

// import 'package:crud_yt_basic/globals.dart' as globals;
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';

// class CalificacionPantalla extends StatefulWidget {
//   final double calificacion;

//   const CalificacionPantalla({super.key, required this.calificacion});

//   @override
//   State<CalificacionPantalla> createState() => _CalificacionPantallaState();
// }

// class _CalificacionPantallaState extends State<CalificacionPantalla> {
//   final ScreenshotController screenshotController = ScreenshotController();

//   Future<void> _shareScreenshot() async {
//     try {
//       await Future.delayed(const Duration(milliseconds: 200)); // Espera breve

//       // Captura la imagen de la pantalla
//       final image = await screenshotController.capture();

//       if (image != null) {
//         final tempDir = await getTemporaryDirectory();
//         final file = await File('${tempDir.path}/screenshot.png').writeAsBytes(image);

//         final xfile = XFile(file.path);
//         await Share.shareXFiles(
//           [xfile],
//           text: 'Calificación: ${widget.calificacion.toStringAsFixed(2)} sobre 100',
//         );
//       } else {
//         debugPrint("Error: No se pudo capturar la imagen");
//       }
//     } catch (e) {
//       debugPrint("Error al compartir: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reportes'),
//       ),
//       body: Screenshot(
//         controller: screenshotController, // Controlador de captura
//         child: Center(
//           child: Text(
//             '${globals.globalUsername}\n'
//             'Tu calificación es:\n${widget.calificacion.toStringAsFixed(2)} sobre 100',
//             style: const TextStyle(fontSize: 24),
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           try {
//             await _shareScreenshot();
//           } catch (e) {
//             debugPrint("Error al intentar compartir: $e");
//           }
//         },
//         backgroundColor: Colors.purple,
//         child: const Icon(Icons.share, color: Colors.white),
//       ),
//     );
//   }
// }


import 'dart:io';

import 'package:crud_yt_basic/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class CalificacionPantalla extends StatefulWidget {
  final double calificacion;

  const CalificacionPantalla({super.key, required this.calificacion});

  @override
  State<CalificacionPantalla> createState() => _CalificacionPantallaState();
}

class _CalificacionPantallaState extends State<CalificacionPantalla> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _shareScreenshot() async {
    try {
      await Future.delayed(const Duration(milliseconds: 200)); // Espera breve

      // Captura la imagen de la pantalla
      final image = await screenshotController.capture();

      if (image != null) {
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/screenshot.png').writeAsBytes(image);

        final xfile = XFile(file.path);
        await Share.shareXFiles(
          [xfile],
          text: 'Calificación: ${widget.calificacion.toStringAsFixed(2)} sobre 100',
        );
      } else {
        debugPrint("Error: No se pudo capturar la imagen");
      }
    } catch (e) {
      debugPrint("Error al compartir: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: Colors.purple, // Color de fondo personalizado
          padding: const EdgeInsets.all(20.0), // Agregar margen interno
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${globals.globalUsername}\n',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white, // Color de texto
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tu calificación es:\n${widget.calificacion.toStringAsFixed(2)} sobre 100',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white, // Color de texto
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _shareScreenshot();
          } catch (e) {
            debugPrint("Error al intentar compartir: $e");
          }
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.share, color: Colors.white),
      ),
    );
  }
}
