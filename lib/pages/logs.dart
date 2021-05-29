import 'package:flutter/material.dart';

class LogsView extends StatefulWidget {
  @override
  _LogsViewState createState() => _LogsViewState();
}

class _LogsViewState extends State<LogsView> {
  List logdata = <String>[
    "rbtkgbbgosbg;oberl ehlifh3;o4h rqp3 rhqwj fl/qwehfehoih liqer vlerhbefvfn aflbvierh  rhfwei fihihwef hijfphfknewf iehfphwepfhel"
  ];
  List moods = <String>["Happy"];
  List dates = <String>["May 30, 2021"];
  List times = <String>["4:01 AM"];

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
                itemCount: logdata.length,
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
                    logdata[i],
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
                          moods[i],
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          dates[i],
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          times[i],
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
