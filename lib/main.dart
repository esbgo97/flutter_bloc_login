import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final String title = "Bloc APP";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text("Hola Bloc!"),
        ),
      ),
    );
  }
}
