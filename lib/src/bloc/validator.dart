
import 'dart:async';

import 'package:qr_app_flutter/src/models/scan_model.dart';

class Validator {
  
  final validatorGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final geoScans = scans.where((s) => s.tipo == 'geo').toList();
      sink.add(geoScans);
    }
  );


  final validatorHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (scans, sink) {
      final geoScans = scans.where((s) => s.tipo == 'http').toList();
      sink.add(geoScans);
    }
  );
}