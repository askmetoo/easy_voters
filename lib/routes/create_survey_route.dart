import 'package:flutter/material.dart';

class CreateSurveyRoute extends StatefulWidget {
  @override
  CreateSurveyRouteState createState() => new CreateSurveyRouteState();
}

class CreateSurveyRouteState extends State<CreateSurveyRoute> {
  // Create a global key that will uniquely identify the `Form` widget
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(
          'Create Your Survey',
        ),
        centerTitle: true,
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return new Form(
      key: _formKey,
      child: new Column(
        children: <Widget>[
          new TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Name is required.';
              }
            },
            decoration: new InputDecoration(
              labelText: 'Name',
            ),
          ),
          new RaisedButton(
            child: new Text('Submit'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                // If the form is valid, we want to show a Snackbar

              }
            },
          )
        ],
      ),
    );
  }
}
