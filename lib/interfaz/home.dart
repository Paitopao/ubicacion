import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../controlador/controladorGeneral.dart';
import '../proceso/peticiones.dart';
import 'listar.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'reto 4',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Donde Estoy'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  controladorGeneral Control = Get.find();

  void ObtenerPosicion() async {
    Position posicion = await PeticionesDB.determinePosition();
    print(posicion.toString());
    Control.cargaUnaPosicion(posicion.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Alert(
                        type: AlertType.warning,
                        context: context,
                        title: "ATENCION!!!",
                        buttons: [
                          DialogButton(
                              color: Colors.lime,
                              child: Text("SI"),
                              onPressed: () {
                                PeticionesDB.EliminarTodas();
                                Control.CargarTodaBD();
                                Navigator.pop(context);
                              }),
                          DialogButton(
                              color: Colors.teal,
                              child: Text("NO"),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                        desc:
                            "Esta seguro que desea eliminar TODAS LAS UBICACIONES?")
                    .show();
              },
              icon: Icon(Icons.delete_rounded))
        ],
      ),
      body: listar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ObtenerPosicion();
          Alert(
                  title: "ATENCION!!!",
                  desc: "Esta seguro que desea almacenar su ubicacion. " +
                      Control.unaPosicion +
                      "?",
                  type: AlertType.info,
                  buttons: [
                    DialogButton(
                        color: Colors.yellow,
                        child: Text("SI"),
                        onPressed: () {
                          PeticionesDB.GuardarPosicion(
                              Control.unaPosicion, DateTime.now().toString());
                          Control.CargarTodaBD();
                          Navigator.pop(context);
                        }),
                    DialogButton(
                        color: Colors.red,
                        child: Text("NO"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                  context: context)
              .show();
        },
        child: Icon(Icons.location_history),
      ),
    );
  }
}
