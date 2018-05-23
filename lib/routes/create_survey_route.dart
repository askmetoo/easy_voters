import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:voters/routes/notify_route.dart';

class CreateSurveyRoute extends StatefulWidget {
  @override
  CreateSurveyRouteState createState() => new CreateSurveyRouteState();
}

class CreateSurveyRouteState extends State<CreateSurveyRoute> {
  // Create a global key that will uniquely identify the `Form` widget
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _db = Firestore.instance.collection('surveys');
  final _options = List<Widget>();
  final _controllers = List<TextEditingController>();
  final _nameController = new TextEditingController();

  var _accepted_terms = false;

  @override
  void initState() {
    super.initState();

    _buildOptionTextField();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(
          'Create Your Survey',
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
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
              controller: _nameController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Name is required.';
                }
              },
              decoration: InputDecoration(
                border: new OutlineInputBorder(),
                hintText: 'Name...',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          new Expanded(
            child: new ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (_, int index) => _buildRow(index),
              itemCount: _options.length,
            ),
          ),
          new ButtonBar(
            children: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  _nameController.clear();
                  for (var controller in _controllers) controller.clear();
                },
              ),
              new RaisedButton(
                child: new Text('SUBMIT'),
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

  void _buildOptionTextField() {
    print('adding option');
    final _textController = new TextEditingController();
    _controllers.add(_textController);
    setState(
      () {
        _options.add(
          new TextFormField(
            controller: _textController,
            // validator: (value) {
            //   if (value.isEmpty) {
            //     return 'Option is required.';
            //   }
            // },
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(32.0)),
              ),
              hintText: 'Option...',
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        );
      },
    );
  }

  void _removeTextField() {
    if (_options.length < 2) return;
    print('removing option');
    setState(() {
      _options.removeLast();
    });
    _controllers.removeLast();
  }

  Widget _buildRow(int index) {
    final _last = index == _options.length - 1;
    final _controls = !_last
        ? new Container()
        : new Row(
            children: [
              new IconButton(
                icon: new Icon(
                  Icons.add,
                ),
                onPressed: _buildOptionTextField,
              ),
              new IconButton(
                icon: new Icon(Icons.remove),
                onPressed: _removeTextField,
              ),
            ],
          );

    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        children: [
          new Expanded(
            child: _options[index],
          ),
          _controls,
        ],
      ),
    );
  }

  Future<Null> _showTerms() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Terms and Conditions'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('You will never be satisfied.'),
                new Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Decline'),
              onPressed: () {
                _accepted_terms = false;
                Navigator.of(context).pop();
              },
              textColor: Colors.black,
            ),
            new RaisedButton(
              child: new Text('Accept'),
              onPressed: () {
                _accepted_terms = true;
                Navigator.of(context).pop();
              },
              textColor: Colors.black,
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit() async {
    await _showTerms();
    if (!_accepted_terms) return;

    print('Submitting forum... Num of controllers: ' +
        _controllers.length.toString());

    DocumentReference ref = await _db.add({
      'multi-select': false,
      'name': _nameController.text,
    });

    for (var controller in _controllers) {
      ref.collection('options').document(controller.text).setData({
        'votes': 0,
      });
    }

    Navigator.pop(context);

    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        // Add 20 lines from here...
        builder: (BuildContext context) {
          return NotifyRoute(docId: ref.documentID);
        },
      ),
    );
  }
}
