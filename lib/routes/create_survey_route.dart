import 'package:flutter/material.dart';

class CreateSurveyRoute extends StatefulWidget {
  @override
  CreateSurveyRouteState createState() => new CreateSurveyRouteState();
}

class CreateSurveyRouteState extends State<CreateSurveyRoute> {
  // Create a global key that will uniquely identify the `Form` widget
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final _options = List<Widget>();

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
          new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name is required.';
                }
              },
              decoration: InputDecoration(
                border: new OutlineInputBorder(),
                hintText: 'Name...',
                filled: true,
              ),
            ),
          ),
          new Expanded(
            child: new ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (_, int index) => _options[index],
              itemCount: _options.length,
            ),
          ),
          new ButtonBar(
            children: <Widget>[
              new RaisedButton(
                child: new Text('Plus'),
                onPressed: _buldOptionTextField,
              ),
              new RaisedButton(
                child: new Text('Minus'),
                onPressed: () {
                  print('removing option');
                  setState(() {
                    _options.removeLast();
                  });
                },
              ),
              new RaisedButton(
                child: new Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState.validate()) _handleSubmit();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _buldOptionTextField() {
    print('adding option');
    setState(() {
      _options.add(
        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: new TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Option is required. Remove it if you no longer need it.';
              }
            },
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(32.0)),
              ),
              hintText: 'Option...',
            ),
          ),
        ),
      );
    });
  }

  void _handleSubmit() {
    print('Submitting forum...');
  }
}
