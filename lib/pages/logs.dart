import 'package:flutter/material.dart';

class LogsView extends StatefulWidget {
  final List<String> logdata;
  final List<String> moods;
  final List<String> dates;
  const LogsView({Key ? key, required this.logdata, required this.dates, required this.moods}) : super(key: key);
  @override
  _LogsViewState createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Aur Sunao!",
                    style: TextStyle(
                      fontFamily: "Chewy",
                      color: Colors.deepPurple[800],
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
            Text("Logs"),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.logdata.length,
                itemBuilder: (BuildContext context, int pos) {
                  return getLogCard(pos);
                }),
          ],
        ),
      ),
    );
  }

  Widget getLogCard(int i) {
    return Card(
      margin: EdgeInsets.fromLTRB(25, 0, 25, 25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: Colors.amber,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Text(
                    widget.logdata[i],
                  ),
                ),
              ),
            ],
          ),
          Container(
            color: Colors.amber[50],
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.moods[i],
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          widget.dates[i],
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
