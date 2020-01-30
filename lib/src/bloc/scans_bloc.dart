

import 'dart:async';

import 'package:qr_app_flutter/src/bloc/validator.dart';
import 'package:qr_app_flutter/src/providers/db_providers.dart';

class ScansBloc with Validator {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    // Obtener scans de la BD
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStreamOriginal => _scansController.stream;
  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validatorGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validatorHttp);

  dispose() {
    _scansController?.close();
  }

  agregarScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  obtenerScans() async {
    _scansController.sink.add( await DBProvider.db.getTodosScans());
  }

  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTodos() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }


}