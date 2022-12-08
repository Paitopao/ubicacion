import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../controlador/controladorGeneral.dart';
import '../proceso/peticiones.dart';

class listar extends StatefulWidget {
  const listar({super.key});

  @override
  State<listar> createState() => _listarState();
}

class _listarState extends State<listar> {
  controladorGeneral Control = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Control.CargarTodaBD();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          child: Control.ListaPosiciones?.isEmpty == false
              ? ListView.builder(
                  itemCount: Control.ListaPosiciones!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                      leading: Icon(Icons.location_searching),
                      trailing: IconButton(
                          onPressed: () {
                            Alert(
                                    type: AlertType.warning,
                                    context: context,
                                    title: "ATENCION!!!",
                                    buttons: [
                                      DialogButton(
                                          color: Colors.indigo,
                                          child: Text("SI"),
                                          onPressed: () {
                                            PeticionesDB.EliminarUnaPosicion(
                                                Control.ListaPosiciones![index]
                                                    ["id"]);
                                            Control.CargarTodaBD();
                                            Navigator.pop(context);
                                          }),
                                      DialogButton(
                                          color: Colors.pink,
                                          child: Text("NO"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          })
                                    ],
                                    desc:
                                        "Esta seguro que desea eliminar esta posicion?")
                                .show();
                          },
                          icon: Icon(Icons.delete)),
                      title:
                          Text(Control.ListaPosiciones![index]["coordenadas"]),
                      subtitle: Text(Control.ListaPosiciones![index]["fecha"]),
                    ));
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
