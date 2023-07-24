import 'dart:convert';

import 'package:flutter/material.dart';
import '../controllers/via_cep_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _searchCepController = TextEditingController();
  bool _loading = false;
  bool _enableField = true;
  String _result = '';
  dynamic? jsonData;

  @override
  void dispose() {
    super.dispose();
    _searchCepController.clear();
  }

  void clearText() {
    _searchCepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar CEP'),
        titleTextStyle: TextStyle(color: Colors.black),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSearchCepTextField(),
            _buildSearchCepButton(),
            _buildResultForm(),
            _buildButtonClear(),
            //  _buildReturn(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCepTextField() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(labelText: 'Cep'),
      controller: _searchCepController,
      enabled: _enableField,
    );
  }

  Widget _buildSearchCepButton() {
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ElevatedButton(
          onPressed: _searchCep,
          child: _loading ? _circularLoading() : Text('Consultar'),
        ));
  }

  void _searching(bool enable) {
    setState(() {
      _result = enable ? '' : _result;
      _loading = enable;
      _enableField = !enable;
    });
  }

  Widget _circularLoading() {
    return Container(
      height: 15.0,
      width: 15.0,
      child: CircularProgressIndicator(),
    );
  }

  Future _searchCep() async {
    _searching(true);

    final cep = _searchCepController.text;

    final fieldText = TextEditingController();

    final resultCep = await ViaCepService.fetchCep(cep: cep);
    setState(() {
      _result = resultCep.toJson();
      jsonData = jsonDecode(resultCep.toJson());
    });
    _searching(false);
  }

  Widget _buildResultForm() {
    String msg = "Informe o cep acima e clique em consulta !";
    if (jsonData != null) {
      return Column(children: [
        TextField(
          decoration: InputDecoration(labelText: 'CEP'),
          controller: TextEditingController(text: jsonData['cep']),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Logradouro'),
          controller: TextEditingController(text: jsonData['logradouro']),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Complemento'),
          controller: TextEditingController(text: jsonData['complemento']),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Bairro'),
          controller: TextEditingController(text: jsonData['bairro']),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Localidade'),
          controller: TextEditingController(text: jsonData['localidade']),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'UF'),
          controller: TextEditingController(text: jsonData['uf']),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'IBGE'),
          controller: TextEditingController(text: jsonData['ibge']),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'GIA'),
          controller: TextEditingController(text: jsonData['gia']),
        ),
      ]);
    }
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Text(msg),
    );
  }

  Widget _buildButtonClear() {
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: ElevatedButton(
          onPressed: clearText,
          child: const Text('Limpar'),
        ));
  }
}
