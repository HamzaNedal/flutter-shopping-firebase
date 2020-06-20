import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/ui_elements/adaptive_progress_indicator.dart';
import '../scoped_models/main.dart';

class AddAddress extends StatefulWidget {
  //  final MainModel model;
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, dynamic> _address = {
    'name': null,
    'addressline': null,
    'city': null,
    'zip': 0,
    'phone': null,
  };

  Widget _buildTitleTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) => _address['name'] = value,
            validator: (String value) {
              return value.trim().isEmpty ? 'The name cannot be empty' : null;
            },
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: 'Name')));
  }

  Widget _buildAddresslineTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) => _address['addressline'] = value,
            validator: (String value) {
              return value.trim().isEmpty ? 'The Street cannot be empty' : null;
            },
            // maxLines: 4,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: 'Street')));
  }

  Widget _buildCityTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) => _address['city'] = value,
            validator: (String value) {
              return value.trim().isEmpty ? 'The city cannot be empty' : null;
            },
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: 'City')));
  }

  Widget _buildZipTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) => _address['zip'] = int.parse(value),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'The zip code cannot be empty';
              }
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Zip Code')));
  }

  Widget _buildPhoneTextField() {
    return ListTile(
        title: TextFormField(
            onSaved: (String value) => _address['phone'] = int.parse(value),
            validator: (String value) {
              if (value.trim().isEmpty) {
                return 'The phone  cannot be empty';
              }
            },
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Phone Number')));
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? Center(child: AdaptiveProgressIndicator())
          : RaisedButton(
              color: Colors.blue,
              onPressed: () => _submitForm(model.addAddress, model),
              child: Text('SAVE'),
              textColor: Colors.white);
    });
  }

  void _submitForm(Function addAddress, model) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      addAddress(_address['name'], _address['addressline'], _address['city'],
              _address['zip'], _address['phone'])
          .then((bool success) {
        if (success) {
           model.fetchAddresses(model.dataUser.getInt('id'));
          Navigator.pop(context);
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text('Something Went Wrong.'),
                    content: Text('Please try again later.'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'))
                    ]);
              });
        }
      });
      Navigator.pushReplacementNamed(context, '/address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Add Address"),
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Form(
              key: _formKey,
              child: ListView(children: <Widget>[
                _buildTitleTextField(),
                _buildAddresslineTextField(),
                _buildCityTextField(),
                _buildZipTextField(),
                _buildPhoneTextField(),
                ListTile(title: _buildSubmitButton())
              ]));
        },
      ),
    );
  }
}
