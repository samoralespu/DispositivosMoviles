
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/models/data_model.dart';
import 'package:flutter_sqlite/pages/home_page.dart';
import 'package:flutter_sqlite/services/db_service.dart';
import 'package:flutter_sqlite/utils/form_helper.dart';

class AddEditProduct extends StatefulWidget {
  AddEditProduct({Key key, this.model, this.isEditMode = false})
      : super(key: key);
  Empresa model;
  bool isEditMode;

  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  Empresa model;
  DBService dbService;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbService = new DBService();
    model = new Empresa();

    if (widget.isEditMode) {
      model = widget.model;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text(widget.isEditMode ? "Editar empresa" : "Agregar empresa"),
      ),
      body: new Form(
        key: globalFormKey,
        child: _formUI(),
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHelper.fieldLabel("Nombre de la empresa"),
                FormHelper.textInput(
                  context,
                  model.nombre,
                  (value) => {
                    this.model.nombre = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Ingrese el nombre de la empresa.';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("URL de la empresa"),
                FormHelper.textInput(
                  context,
                  model.url,
                  (value) => {
                    this.model.url = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Ingrese el URL de la empresa.';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("telefono de la empresa"),
                FormHelper.textInput(
                  context,
                  model.telefono,
                  (value) => {this.model.telefono = int.parse(value)},
                  onValidate: (value) {
                    if (value == null) {
                      return 'Ingrese el telefono de la empresa.';
                    }
                    return null;
                  },
                  isNumberInput: true
                ),
                FormHelper.fieldLabel("email de la empresa"),
                FormHelper.textInput(
                  context,
                  model.email,
                  (value) => {
                    this.model.email = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Ingrese el email de la empresa.';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("servicios de la empresa"),
                FormHelper.textInput(
                  context,
                  model.servicios,
                  (value) => {
                    this.model.servicios = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Ingrese los servicios de la empresa.';
                    }
                    return null;
                  },
                ),
                
                FormHelper.fieldLabel("Clasificacion de la empresa"),
                _productCategory(),
                btnSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _productCategory() {
    return FutureBuilder<List<CategoryModel>>(
      future: dbService.getCategories(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CategoryModel>> categories) {
        if (categories.hasData) {
          return FormHelper.selectDropdown(
            context,
            model.clasificacion,
            categories.data,
            (value) => {this.model.clasificacion = int.parse(value)},
            onValidate: (value) {
              if (value == null) {
                return 'Ingrese la clasificacion de la empresa.';
              }
              return null;
            },
          );
        }

        return CircularProgressIndicator();
      },
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget btnSubmit() {
    return new Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          if (validateAndSave()) {
            print(model.toMap());
            if (widget.isEditMode) {
              dbService.updateEmpresa(model).then((value) {
                FormHelper.showMessage(
                  context,
                  "SQFLITE CRUD",
                  "Data Submitted Successfully",
                  "Ok",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                );
              });
            } else {
              dbService.addEmpresa(model).then((value) {
              FormHelper.showMessage(
                  context,
                  "SQFLITE CRUD",
                  "Data Modified Successfully",
                  "Ok",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                );
              });
            }
          }
        },
        child: Container(
          height: 40.0,
          margin: EdgeInsets.all(10),
          width: 100,
          color: Colors.blueAccent,
          child: Center(
            child: Text(
              "Guardar empresa",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
