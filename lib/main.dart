import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Friendlychat",
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

/// If you want to visually present stateful data in a widget,
/// you should encapsulate this data in a State object.
class ChatScreenState extends State<ChatScreen> {

  /// To manage interactions with the TextField.
  /// For reading the contents and clearing the field after the message is sent.
  final TextEditingController _textController = new TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
  }

  Widget _buildTextComposer() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[

          /// wrap the TextField widget in a Flexible widget.
          /// This tells the Row to automatically size the text field
          /// to use the remaining space that isn't used by the button.
          new Flexible(
            child: new TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: new InputDecoration.collapsed(
                  hintText: "Send a message"),
            ),
          ),

          new IconButton(
              icon: new Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text)
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Friendly chat")),
      body: _buildTextComposer(),
    );
  }
}
