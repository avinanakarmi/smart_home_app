import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => (runApp(MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smart Home App",
      home: HomePage(),
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: TextTheme(
          display1: new TextStyle(color: Colors.white, fontSize: 20),
          display2: new TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          display3: new TextStyle(color: Colors.black, fontSize: 16),
          display4: new TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
          subtitle: new TextStyle(color: Colors.black, fontSize: 14),
          caption: new TextStyle(color: Colors.grey, fontSize: 12),
        )
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String name = "John";
  List<Map<String, String>> rooms = [
    {"name":"Living Room", "noOfDevices":"5"},
    {"name":"Bedroom", "noOfDevices":"4"},
    {"name":"Kitchen", "noOfDevices":"6"},
    {"name":"Garage", "noOfDevices":"2"}
  ];

  var children = <Widget>[];

  Widget _memberInfo(name, status){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Center(
        child: new Column ( 
          children: <Widget>[
            new CircleAvatar(
              backgroundColor: Color.fromRGBO(0, 76, 153, 0.6),
              child: new Text(name[0], style: TextStyle(color: Colors.white),),
            ),
            new Text(name, style: Theme.of(context).textTheme.subtitle),
            new Text(status, style: Theme.of(context).textTheme.caption),
          ],
        )
      ),
    );
  }

  Widget _roomWidget(room, noOfDevices) {
    Icon icon;
    switch (room) {
      case "Bedroom":
        icon = new Icon(MdiIcons.bedKingOutline, size: 50, color: Color.fromRGBO(0, 76, 153, 0.6),);
        break;
      case "Garage":
        icon = new Icon(MdiIcons.garage, size: 50, color: Color.fromRGBO(0, 76, 153, 0.6),);
        break;
      case "Kitchen":
        icon = new Icon(MdiIcons.stove, size: 40, color: Color.fromRGBO(0, 76, 153, 0.6),);
        break;
      default:
        icon = new Icon(MdiIcons.sofa, size: 40, color: Color.fromRGBO(0, 76, 153, 0.6),);
    }

    return Card(
      elevation: 10.0,
      child: Container(
        height: 140,
        width: 140,
        padding: EdgeInsets.all(10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                new Container(
                  height: 77,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      icon,
                    ],
                  ),
                ),
                new Text(room, style: Theme.of(context).textTheme.display3,),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(noOfDevices + " devices", style: Theme.of(context).textTheme.display4),
                    new Icon(Icons.keyboard_arrow_right, color: Color.fromRGBO(0, 76, 153, 0.6),)
                  ],
                )
              ]
            )
          ]
        ),
      )
    );
  }

  Widget _scrollableCardWidget() {
    return Card(
      elevation: 10.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _memberInfo("Cathy", "active"),
              _memberInfo("Freddie", "active"),
              _memberInfo("Brian", "inactive"),
              _memberInfo("Robert", "active"),
              _memberInfo("Micheal", "inactive")
            ]
          ),
        ),
      ),
    );
  }

  Widget _contentWidget() {
    for(int i=0; i<rooms.length; i+=2) {
      children.add(
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(i.toString()),
            _roomWidget(rooms[i]['name'], rooms[i]['noOfDevices']),
            _roomWidget(rooms[i+1]['name'], rooms[i+1]['noOfDevices'])
          ],
        )
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.0)
        )
      ),
      child: new Column(
        children: <Widget> [
          Padding(
            padding: const EdgeInsets.all(36.0),
            child: new Text("Rooms", style: Theme.of(context).textTheme.display2),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45.0, right: 45.0, bottom: 20.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children
            ),  
          ),
          new Divider(),
          Padding(
            padding: const EdgeInsets.all(36.0),
            child: new Text("Other residents", style: Theme.of(context).textTheme.display2),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45.0, right: 45.0, bottom: 20.0),
            child: _scrollableCardWidget()
          )
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: new Scaffold(
              body: new SingleChildScrollView(
                child: new Center(
                  child: new Column(
                    children: <Widget>[
                      new AppBar(
                        title: new Text("Hi " + name + "!", style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 30),),
                        centerTitle: true,
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        actions: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 27.0, vertical: 9.0),
                            width: 90,
                            child: new CircleAvatar(
                              backgroundImage: new AssetImage("assets/images/john.jpeg"),
                              radius: 27,
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 120.0),
                        child: new Text("Start managing your home", style: Theme.of(context).textTheme.display1),
                      ),
                      _contentWidget()
                    ],
                  )
                ),
              ),
              backgroundColor: Colors.black,
            ),
    );
  }
}