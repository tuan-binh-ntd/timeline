import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/timeline.dart';
import '../database/database_helper.dart';

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
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder<List<TimelineModel>>(
            future: DatabaseHelper.instance.getGroceries(),
            builder: (BuildContext context,
                AsyncSnapshot<List<TimelineModel>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return snapshot.data.isEmpty
                  ? Center(
                      child: Text("sadsadasd"),
                    )
                  : ListView(
                      children: snapshot.data.map((grocery) {
                        return Center(
                          child: ListTile(
                            title: Text(grocery.name),
                          ),
                        );
                      }).toList(),
                    );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () async {
          await DatabaseHelper.instance.add(
            TimelineModel(name: textController.text),
          );
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
