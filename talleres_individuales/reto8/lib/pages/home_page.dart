import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/models/data_model.dart';
import 'package:flutter_sqlite/pages/add_edit_product.dart';
import 'package:flutter_sqlite/services/db_service.dart';
import 'package:flutter_sqlite/utils/form_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBService dbService;

  @override
  void initState() {
    super.initState();
    dbService = new DBService();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("SQFLITE CRUD"),
      ),
      body: _fetchData(),
    );
  }

  Widget _fetchData() {
    return FutureBuilder<List<Empresa>>(
      future: dbService.getEmpresas(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Empresa>> empresas) {
        if (empresas.hasData) {
          return _buildUI(empresas.data);
        }

        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildUI(List<Empresa> empresas) {
    List<Widget> widgets = new List<Widget>();

    widgets.add(
      new Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditProduct(),
              ),
            );
          },
          child: Container(
            height: 40.0,
            width: 100,
            color: Colors.blueAccent,
            child: Center(
              child: Text(
                "Añadir empresa",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildDataTable(empresas)],
      ),
    );

    return Padding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
      padding: EdgeInsets.all(10),
    );
  }

  Widget _buildDataTable(List<Empresa> model) {
    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            "Empresa",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "url",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Action",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      sortColumnIndex: 1,
      rows: model.map(
            (data) => DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(
                    data.nombre,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DataCell(
                  Text(
                    data.nombre,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DataCell(
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditProduct(
                                  isEditMode: true,
                                  model: data,
                                ),
                              ),
                            );
                          },
                        ),
                        new IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            FormHelper.showMessage(
                              context,
                              "SQFLITE CRUD",
                              "Do you want to delete this record?",
                              "Yes",
                              () {
                                dbService.deleteEmpresa(data).then((value) {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                });
                              },
                              buttonText2: "No",
                              isConfirmationDialog: true,
                              onPressed2: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
