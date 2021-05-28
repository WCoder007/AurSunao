import 'package:aursunao/pages/homepage.dart';
import 'package:aursunao/sidebar/sidebar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aur Sunao',
      theme: ThemeData(
          // scaffoldBackgroundColor: Colors.deepPurple[100],
          scaffoldBackgroundColor: Colors.white70,
          primarySwatch: Colors.deepPurple,
          fontFamily: "NotoSans"),
      home: App(title: 'Aur Sunao!'),
    );
  }
}

class App extends StatefulWidget {
  App({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Icon(Icons.menu_rounded),
      //   centerTitle: true,
      //   title: Text(
      //     widget.title,
      //     style: TextStyle(
      //       fontFamily: 'Chewy',
      //       fontSize: 30,
      //     ),
      //   ),
      // ),
      body: Stack(
        children: <Widget>[
          HomePage(),
          SideBar(),
        ],
      ),
    );
  }
}
