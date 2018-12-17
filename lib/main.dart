import 'package:flutter/material.dart';

const String _person_name = "Ankit";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Friendlychat",
      home: new ChatScreen(),
      theme: ThemeData.light(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new FadeTransition(
        opacity: new CurvedAnimation(
            parent: animationController, curve: Curves.decelerate),
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            /// For the avatar, the parent is a Row widget whose main axis is horizontal.
            /// So, CrossAxisAlignment.start gives it the highest position along the vertical axis
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Avatar
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(child: new Text(_person_name[0])),
              ),
              new Column(
                /// Since for a column the main axis is vertical,
                /// the CrossAxisAlignment.start aligns the text at the furthest left position along the horizontal axis.
                crossAxisAlignment: CrossAxisAlignment.start,

                /// 2 text-boxes: Sender name & actual message
                children: <Widget>[
                  new Text(_person_name,
                      style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

/// If you want to visually present stateful data in a widget,
/// you should encapsulate this data in a State object.
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  /// ========================= Stateful data here =============================
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isComposing = false;

  /// To manage interactions with the TextField.
  /// For reading the contents and clearing the field after the message is sent.
  final TextEditingController _textController = new TextEditingController();

  void _handleSubmitted(String text) {
    _isComposing = false;
    _textController.clear();
    ChatMessage chatMessage = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 600), //new
        vsync: this,
      ),
    );

    /// You call setState()to modify _messages and to let the framework know
    /// this part of the widget tree has changed and it needs to rebuild the UI.
    setState(() {
      _messages.insert(0, chatMessage);

      /// Only synchronous operations should be performed in setState(),
      /// because otherwise the framework could rebuild the widgets before the operation finishes.
    });

    /// Run the animation
    chatMessage.animationController.forward();
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      /// This gives all widgets the accent color of the current theme.
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
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
                onChanged: (String text) {
                  setState(() {
                    _isComposing = (text.length > 0);
                  });
                },
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),

            new IconButton(
              icon: new Icon(Icons.send),
              onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)
                  : null, /// onPressed being null makes the button grayed out
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Friendly chat")),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),

              /// to make the ListView start from the bottom of the screen
              reverse: true,

              /// Naming the argument _ (underscore) is a convention to indicate that it won't be used.
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}
