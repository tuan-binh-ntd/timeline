import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:timeline_management/model/timeline.dart';
import 'database/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timeline Management"),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 75,
                      child: Text(
                        "Ngày",
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.normal),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 55,
                      child: Text(
                        "Vào",
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.normal),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 55,
                      child: Text(
                        "Ra",
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.normal),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        "Số giờ",
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.normal),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          FutureBuilder<List<TimelineModel>>(
              future: DatabaseHelper.instance.getTimelineList(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<TimelineModel>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text('Loading...'));
                }
                return snapshot.data.isEmpty
                    ? Center(
                        child: Text("Timeline"),
                      )
                    : SingleChildScrollView(
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: snapshot.data.map((element) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    element.startTime != null
                                        ? SizedBox(
                                            width: 75,
                                            child: Text(element.startTime
                                                .substring(0, 10)),
                                          )
                                        : SizedBox(width: 75, child: Text(""))
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    element.startTime != null
                                        ? SizedBox(
                                            width: 55,
                                            child: Text(element.startTime
                                                .substring(11, 19)),
                                          )
                                        : SizedBox(width: 55, child: Text(""))
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    element.finishTime != null
                                        ? SizedBox(
                                            width: 55,
                                            child: Text(element.finishTime
                                                .substring(11, 19)),
                                          )
                                        : SizedBox(
                                            width: 55, child: Text("Chưa có"))
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    element.time != null
                                        ? SizedBox(
                                            width: 60,
                                            child: Text(DatabaseHelper.instance
                                                .formatedTime(
                                                    timeInSecond:
                                                        element.time)),
                                          )
                                        : SizedBox(
                                            width: 60, child: Text("Chưa có"))
                                  ],
                                )
                              ],
                            );
                          }).toList(),
                        ),
                      );
              }),
          Expanded(
            child: Align(
              alignment: FractionalOffset.center,
              child: Row(children: [
                FutureBuilder<double>(
                    future: DatabaseHelper.instance.timeTotal(),
                    builder:
                        (BuildContext context, AsyncSnapshot<double> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text('Loading...'));
                      }
                      return snapshot.data == null
                          ? Center(
                              child: Text("Timeline"),
                            )
                          : Text(DatabaseHelper.instance
                              .formatedTime(timeInSecond: snapshot.data));
                    }),
              ]),
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () async {
                await DatabaseHelper.instance.add(
                    TimelineModel(startTime: DateTime.now().toIso8601String()));
                setState(() {
                  textController.clear();
                });
              },
            ),
            Expanded(child: Container()),
            FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: () async {
                await DatabaseHelper.instance.edit(TimelineModel(
                    finishTime: DateTime.now().toIso8601String()));
                setState(() {
                  textController.clear();
                });
              },
            ),
            Expanded(child: Container()),
            FloatingActionButton(
              child: Icon(Icons.remove),
              onPressed: () async {
                await DatabaseHelper.instance.remove();
                setState(() {
                  textController.clear();
                });
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.deepPurple,
        color: Colors.deepPurple.shade200,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {},
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.favorite,
            color: Colors.white,
          ),
          Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
