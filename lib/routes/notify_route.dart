import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

const ROOT_URL =
    'https://us-central1-voter-a604f.cloudfunctions.net/sendEmail?email=';

class NotifyRoute extends StatefulWidget {
  final String docId;

  NotifyRoute({this.docId});

  @override
  NotifyRouteState createState() => new NotifyRouteState();
}

class NotifyRouteState extends State<NotifyRoute> {
  // Create a global key that will uniquely identify the `Form` widget
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _emails = List<Widget>();
  final _controllers = List<TextEditingController>();
  final _ownerEmailController = new TextEditingController();

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
          'Notifying Voters',
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
              controller: _ownerEmailController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Your email is required.';
                }
              },
              decoration: InputDecoration(
                border: new OutlineInputBorder(),
                hintText: 'Your email...',
                filled: true,
              ),
            ),
          ),
          new Expanded(
            child: new ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (_, int index) => _buildRow(index),
              itemCount: _emails.length,
            ),
          ),
          new ButtonBar(
            children: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  _ownerEmailController.clear();
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
        _emails.add(
          new TextFormField(
            controller: _textController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Additional email is required.';
              }
            },
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(32.0)),
              ),
              hintText: 'Additional Email...',
            ),
          ),
        );
      },
    );
  }

  void _removeTextField() {
    if (_emails.length < 2) return;
    print('removing option');
    setState(() {
      _emails.removeLast();
    });
    _controllers.removeLast();
  }

  Widget _buildRow(int index) {
    final _last = index == _emails.length - 1;
    final _controls = !_last
        ? new Container()
        : new Row(
            children: [
              new IconButton(
                icon: new Icon(Icons.add),
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
            child: _emails[index],
          ),
          _controls,
        ],
      ),
    );
  }

  void _handleSubmit() async {
    print('Testing');
    var url = ROOT_URL + _ownerEmailController.text + '&id=' + widget.docId;
    _sendEmail(url);

    for (var controller in _controllers) {
      url = ROOT_URL + controller.text + '&id=' + widget.docId;
      _sendEmail(url);
    }

    Navigator.pop(context);
  }

  void _sendEmail(var url) async {
    var httpClient = new HttpClient();

    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var data = await response.transform(UTF8.decoder).join();
        result = data;
      } else {
        result =
            'Error getting a random quote:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed invoking the getRandomQuote function.';
    }

    print(result);
  }
}
