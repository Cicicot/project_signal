import 'dart:typed_data';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{
  static Future<void> createTables(sql.Database database) async{
    await database.execute("""CREATE TABLE data(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      createdAt DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
    )""");
  }

  //CREAMOS LA TABLA nivel(idNivel, titulo, descripcion)
  static Future<void> createTableNivel(sql.Database database) async {
    await database.execute("""CREATE TABLE nivel(
      idNivel INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      titulo TEXT,
      descripcion TEXT,
      estado INT NOT NULL,
      fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
      fecha_edicion DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
    )""");
  }

  //CREAMOS LA TABLA usuario(idUsuario, nombre, apellido, correo, contraseña, fecha_nacimiento, perfil)
  static Future<void> createTableUsuario(sql.Database database) async {
    await database.execute("""CREATE TABLE usuario(
      idUsuario INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name_usuario TEXT UNIQUE NOT NULL,
      nombre TEXT NOT NULL,
      apellido TEXT NOT NULL,
      correo TEXT NOT NULL,
      password TEXT NOT NULL,
      fecha_nacimiento TEXT NOT NULL,
      perfil TEXT NOT NULL,
      estado INT NOT NULL,
      fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
      fecha_edicion DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
    )""");
  }

  //CREAMOS LA TABLA leccion(idLeccion, titulo, descripcion)
  static Future<void> createTableLeccion(sql.Database database) async {
    await database.execute("""CREATE TABLE leccion(
      idLeccion INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      titulo TEXT NOT NULL,
      descripcion TEXT NOT NULL,
      estado INT NOT NULL,
      fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
      fecha_edicion DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
    )""");
  }

  static Future<void> createTableContenido(sql.Database database) async {
    await database.execute("""CREATE TABLE contenido (
        idContenido INTEGER PRIMARY KEY AUTOINCREMENT,
        video BLOB,
        significado TEXT NOT NULL
      )""");
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase(
      "database_lsb.db",
      version: 1,
      onCreate: (sql.Database database, int version) async{
        await createTables(database);
        await createTableNivel(database);
        await createTableUsuario(database);
        await createTableLeccion(database);
        await createTableContenido(database);
      }
    );
  }

  //MÉTODOS CRUD

  //CREATE
  static Future<int> createData(String title, String? description) async{    
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'description': description
    };
    final id = await db.insert('data', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> crearNivel(String titulo, String? descripcion) async {
    final db = await SQLHelper.db();
    final nivel = {
      'titulo': titulo,
      'estado': 1,
      'descripcion': descripcion
    };
    final idNivel = await db.insert('nivel', nivel, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return idNivel;
  }

  static Future<int> crearUsuario(String nameUsuario, String nombre, String apellido, String correo, String password, String fechaNacimiento, String perfil) async {
    final db = await SQLHelper.db();
    final usuario = {
      'name_usuario': nameUsuario,
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'password': password,
      'fecha_nacimiento': fechaNacimiento,
      'perfil': perfil,
      'estado': 1
    };
    final idUsuario = await db.insert('usuario', usuario, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return idUsuario;
  }

  static Future<int> crearLeccion(String titulo, String descripcion) async {
    final db = await SQLHelper.db();
    final leccion = {
      'titulo': titulo,
      'estado': 1,
      'descripcion': descripcion
    };
    final idLeccion = await db.insert('leccion', leccion, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return idLeccion;
  }

  static Future<int> crearContenido(Uint8List video, String significado) async {
    final db = await SQLHelper.db();
    final contenido = {
      'video': video,
      'significado': significado
    };
    final idContenido = await db.insert('contenido', contenido, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return idContenido;
  }

  //READ 
  static Future<List<Map<String, dynamic>>> getAllData() async{
    final db = await SQLHelper.db();
    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getAllNivel() async {
    final db = await SQLHelper.db();
    return db.query('nivel', orderBy: 'idNivel');
  }

  static Future<List<Map<String, dynamic>>> getAllUsuario() async {
    final db = await SQLHelper.db();
    return db.query('usuario', orderBy: 'idUsuario');
  }

  static Future<List<Map<String, dynamic>>> getAllLeccion() async {
    final db = await SQLHelper.db();
    return db.query('leccion', orderBy: 'idLeccion');
  }

  static Future<List<Map<String, dynamic>>> getAllContenido() async {
    final db = await SQLHelper.db();
    return db.query('contenido', orderBy: 'idContenido');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async{
    final db = await SQLHelper.db();
    return db.query('data', where: "id=?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getSingleNivel(int id) async {
    final db = await SQLHelper.db();
    return db.query('nivel', where: 'id=?', whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getSingleUsuario(int id) async {
    final db = await SQLHelper.db();
    return db.query('usuario', where: 'idUsuario=?', whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getSingleLeccion(int id) async {
    final db = await SQLHelper.db();
    return db.query('leccion', where: 'idLeccion=?', whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getSingleContenido(int id) async {
    final db = await SQLHelper.db();
    return db.query('contenido', where: 'idContenido=?', whereArgs: [id], limit: 1);
  }

  //UPDATE
  static Future<int> updateData(int id, String title, String? description) async{
    final db = await SQLHelper.db();
    final data = {
      'title' : title,
      'description' : description,
      'createdAt' : DateTime.now().toString()
    };
    final result = await db.update('data', data, where: "id=?", whereArgs: [id]);
    return result;
  }

  static Future<int> updateNivel(int id, String titulo, String? descripcion) async {
    final db = await SQLHelper.db();
    final nivel = {
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha_edicion': DateTime.now().toString()
    };
    final result = await db.update('nivel', nivel, where: "idNivel=?", whereArgs: [id]);
    return result;
  }

  static Future<int> updateUsuario(int id, String nombre, String apellido, String correo, String password, String fechaNacimiento, String perfil) async {
    final db = await SQLHelper.db();
    final usuario = {
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'password': password,
      'fecha_nacimiento': fechaNacimiento,
      'perfil': perfil,
      'fecha_edicion': DateTime.now().toString()
    };
    final result = await db.update('usuario', usuario, where: "idUsuario=?", whereArgs: [id]);
    return result;
  }

  static Future<int> updateLeccion(int id, String titulo, String descripcion) async {
    final db = await SQLHelper.db();
    final leccion = {
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha_edicion': DateTime.now().toString()
    };
    final result = await db.update('leccion', leccion, where: 'idLeccion=?', whereArgs: [id]);
    return result;
  }

  static Future<int> updateContenido(int id, Uint8List video, String significado) async {
    final db = await SQLHelper.db();
    final contenido = {
      'video': video,
      'significado': significado
    };
    final result = await db.update('contenido', contenido, where: 'idContenido=?', whereArgs: [id]);
    return result;
  }

  //DELETE
  static Future<void> deleteData(int id) async{
    final db = await SQLHelper.db();
    try{
      await db.delete('data', where: "id=?", whereArgs: [id]);
    } catch (e){
      throw Exception('No se pudo eliminar el registro');
    }
  }

  static Future<void> deleteNivel(int id) async {
    final db = await SQLHelper.db();
    try{
      await db.delete('nivel', where: "idNivel=?", whereArgs: [id]);
    } catch (e){
      throw Exception('No se pudo eliminar el registro');
    }
  }

  static Future<void> deleteUsuario(int id) async {
    final db = await SQLHelper.db();
    try{
      await db.delete('usuario', where: "idUsuario=?", whereArgs: [id]);
    } catch (e) {
      throw Exception('No se pudo eliminar el usuario');
    }
  }

  static Future<void> deleteLeccion(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('leccion', where: "idLeccion=?", whereArgs: [id]);
    } catch (e) {
      throw Exception('No se pudo eliminar la lección');
    }
  }

  static Future<void> deleteContenido(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('contenido', where: "idContenido=?", whereArgs: [id]);
    } catch (e) {
      throw Exception('No se pudo eliminar el contenido');
    }
  }

  // MÉTODO LOGIN
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final db = await SQLHelper.db();

    var result = await db.rawQuery(
      "SELECT * FROM usuario WHERE name_usuario = ? AND password = ?",
      [username, password]
    );

    if (result.isNotEmpty) {
      return {
        'success': true,
        'tipo': result.first['perfil']
      };
    } else {
      return {
        'success': false
      };
    }
  }
  
}
