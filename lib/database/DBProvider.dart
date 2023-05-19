import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "AppOS.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute(usuario);
      await db.execute(empresa);
      await db.execute(osequipamento);
      await db.execute(equipamento);
      await db.execute(deslocamento);
      await db.execute(arquivos);
      await db.execute(checklist);
      await db.execute(visitafrustrada);
      await db.execute(acessorios);
    });

  }
  String get usuario => """
  CREATE TABLE usuario (
  id INTEGER,
	nome	TEXT,
	logo	TEXT,
	token	TEXT,
	empresa	INTEGER,
	PRIMARY KEY(id AUTOINCREMENT)

)
    """;
  String get empresa => """
  CREATE TABLE empresa (
	id	INTEGER,
	cod	TEXT,
	nome	TEXT,
	logo	TEXT,
	PRIMARY KEY(id AUTOINCREMENT)
);
    """;
  String get osequipamento => """
  CREATE TABLE osequipamento (
	id	INTEGER,
	tipo	TEXT,
	eqretirado	TEXT,
	localinst	TEXT,
	equipamento	INTEGER,
	PRIMARY KEY(id AUTOINCREMENT)
);,
    """;
  String get equipamento => """
  CREATE TABLE equipamento (
	id	INTEGER,
	num	TEXT,
	cod	TEXT,
	doc	TEXT,
	status	TEXT,
	acessorios	INTEGER,
	PRIMARY KEY(id AUTOINCREMENT)
);
    """;
  String get acessorios => """
  CREATE TABLE acessorio (
	id	INTEGER,
	descricao	TEXT,
	PRIMARY KEY(id AUTOINCREMENT)
	);
    """;
  String get deslocamento => """
  CREATE TABLE deslocamento (
	id	INTEGER,
	distancia	REAL,
	desloc	REAL,
	motivodiv	TEXT,
	etapa	TEXT,
	PRIMARY KEY(id AUTOINCREMENT)
);
    """;
  String get arquivos => """
  CREATE TABLE arquivos (
	id	INTEGER,
	base64	TEXT,
	etapa	TEXT,
	idos	INTEGER,
	PRIMARY KEY(id AUTOINCREMENT)
);
    """;
  String get checklist => """
  CREATE TABLE checklist (
	id	INTEGER,
	desc	TEXT,
	situantes	INTEGER,
	situdepois	INTEGER,
	obsantes	TEXT,
	obsdepois	TEXT,
	PRIMARY KEY(id AUTOINCREMENT)
);
    """;
  String get visitafrustrada => """
  CREATE TABLE visitafrustrada (
	id	INTEGER,
	base64	REAL,
	deslocamento	REAL,
	pedagio	REAL,
	motivodiv	TEXT,
	motivo	TEXT,
	localgps	TEXT,
	etapa	TEXT,
	PRIMARY KEY(id AUTOINCREMENT)
);
    """;


}
