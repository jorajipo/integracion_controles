import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferencias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (title: Text("Preferencias"),),
      body: FormPreferencias(),
    );

  }

}


class FormPreferencias extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormPreferenciasState();
  }

}


class FormPreferenciasState extends State<FormPreferencias> {
  // Aquí se construye el ormulario para elegir preferencias
  final _formKey = GlobalKey<FormState>();
  TextEditingController controladorIdioma = TextEditingController();

  //Instancia del archivo de preferencias
  final _prefs = SharedPreferences.getInstance();

  late Future<String> _idioma;
  late Future<String> _moneda;



  //Método para estabñecer el estado inicial
  @override
  void initState() {
    //Aqui voy a cargar las preferencias existentes
    super.initState();
    _idioma = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('idioma') ?? "Español");
    });
  }



  //Método asíncrono que regresa un Future del idioma
  Future<void> _guardarIdioma() async {
    final SharedPreferences prefs = await _prefs;
    final String idioma = controladorIdioma.text;

    setState(() {
      _idioma = prefs.setString("idioma", idioma).then((bool success) {
        return idioma;
      }
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

        //ME construirá un widget de Text a partir del Future<String>
        FutureBuilder<String>(
            future: _idioma,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      'Idioma: ${snapshot.data}',
                    );
                  }
              }
            }),

          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty || value.length <= 1) {
                return 'Escribe un texto de al menos 2 letras';
              }
              return null;
            },
            controller: controladorIdioma,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Preferencia guardada')));
                  _guardarIdioma();
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}