import 'dart:io';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_app_flutter/src/bloc/scans_bloc.dart';
import 'package:qr_app_flutter/src/models/scan_model.dart';

import 'package:qr_app_flutter/src/pages/direcciones_page.dart';
import 'package:qr_app_flutter/src/pages/mapas_page.dart';
// import 'package:qr_app_flutter/src/providers/db_providers.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:qr_app_flutter/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.filter_center_focus ),
        onPressed: () => _scanQA(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQA(BuildContext context) async {
    // String futureString = '';
    // print('Future Strung $futureString');
    String futureString;

    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    if(futureString != null) {
      // print('Tenemos información');
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);
      // DBProvider.db.nuevoScan(scan);

      // final scan2 = ScanModel(valor: 'geo:40.3332222,-74.007');
      // scansBloc.agregarScan(scan2);

      // error IOS para esperar que cierre la camara
      if(Platform.isIOS){
        Future.delayed(Duration(milliseconds: 750), (){
          utils.abrirScan(context, scan);
        });
      } else {
        utils.abrirScan(context, scan);
      }

      
    }
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0: return MapasPage();
      case 1: return DireccionesPage();

      default:
        return MapasPage();
    }
  }

  Widget _appBar() {
    return AppBar(
      title: Text('QR Scanner'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: scansBloc.borrarScanTodos,
        )
      ],
    );
  }

  Widget _crearBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.map ),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.brightness_5 ),
          title: Text('Direcciones')
        )
      ],
    );
  }
}