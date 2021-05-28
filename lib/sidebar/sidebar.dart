import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  bool isSidebarOpen = false;
  late AnimationController _aniController;
  late StreamController<bool> sidebarOpenStramController;
  late Stream<bool> sidebarStream;
  late StreamSink<bool> sidearStreamSink;

  @override
  void initState() {
    super.initState();
    _aniController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    sidebarOpenStramController = PublishSubject<bool>();
    sidebarStream = sidebarOpenStramController.stream;
    sidearStreamSink = sidebarOpenStramController.sink;
  }

  @override
  void dispose() {
    _aniController.dispose();
    sidebarOpenStramController.close();
    sidearStreamSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
        initialData: false,
        stream: sidebarStream,
        builder: (context, snapshot) {
          return AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: 0,
            bottom: 0,
            left: isSidebarOpen ? 0 : -screenWidth,
            right: isSidebarOpen ? 0 : screenWidth - 45,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.deepPurple[800],
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 200),
                        CircleAvatar(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Alice xyz",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 64,
                          thickness: 0.5,
                          color: Colors.white.withOpacity(0.9),
                          indent: 32,
                          endIndent: 32,
                        ),
                        SidebarMenuItem(
                            title: "Record a diary",
                            onTap: () {
                              print("Menu item 1");
                            }),
                        SidebarMenuItem(
                            title: "Logs",
                            onTap: () {
                              print("Menu item 2");
                            }),
                        SidebarMenuItem(
                            title: "Log out",
                            onTap: () {
                              print("Menu item 3");
                            }),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, -0.9),
                  child: GestureDetector(
                    onTap: () {
                      final animationStatus = _aniController.status;
                      if (animationStatus == AnimationStatus.completed) {
                        isSidebarOpen = false;
                        sidearStreamSink.add(false);
                        _aniController.reverse();
                      } else {
                        isSidebarOpen = true;
                        sidearStreamSink.add(true);
                        _aniController.forward();
                      }
                    },
                    child: ClipPath(
                      clipper: CustomMenuClipper(),
                      child: Container(
                        child: AnimatedIcon(
                          icon: AnimatedIcons.arrow_menu,
                          progress: _aniController.view,
                          color: Colors.white,
                        ),
                        color: Colors.deepPurple[800],
                        width: 35,
                        height: 110,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class SidebarMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SidebarMenuItem({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 24, color: Colors.white),
          ),
        ]),
      ),
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}