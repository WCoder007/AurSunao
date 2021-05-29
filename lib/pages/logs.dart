import 'package:flutter/material.dart';

class LogsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50.0),
                  Text(
                    "Aur Sunao!",
                    style: TextStyle(
                      fontFamily: "Chewy",
                      color: Colors.deepPurple[800],
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
            ),
            Text("Logss"),
          ],
        ),
      ),
    );
  }
}
