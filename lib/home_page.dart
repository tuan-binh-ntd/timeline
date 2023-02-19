import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../model/timeline.dart';
import '../database/database_helper.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
  DateFormat fullDateFormat = new DateFormat("yyyy-MM-dd hh:mm:ss");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Center(
            child: FutureBuilder<List<TimelineModel>>(
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
                      : ListView(
                          children: snapshot.data.map((element) {
                            return Row(
                              children: [
                                Column(
                                  children: [
                                    Text(dateFormat.parse(element.startTime).toIso8601String())
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(element.startTime)
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(element.finishTime)
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(element.time)
                                  ],
                                )
                              ],
                            );
                          }).toList(),
                        );
                }),
          ),
          Row(
            children: [
              FutureBuilder<String>(
                future: DatabaseHelper.instance.timeTotal(),
                builder: (BuildContext context,
                    AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('Loading...'));
                  }
                  return snapshot.data.isEmpty
                      ? Center(
                          child: Text("Timeline"),
                        )
                      : Text("$snapshot.data[0]");
                }
              ),
          ])
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {

          setState(() {
            textController.clear();
          });
        },
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
