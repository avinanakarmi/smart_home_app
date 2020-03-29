import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'room.dart';

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
    {"name":"Garage", "noOfDevices":"2"},
    {"name":"Bathroom", "noOfDevices":"3"}
  ];
  List<Map<String, String>> members = [
    {"name":"Cathey", "status":"active"},
    {"name":"Freddie", "status":"active"},
    {"name":"Brian", "status":"inactive"},
    {"name":"Robert", "status":"active"},
  ];

  var roomsChildren = <Widget>[];
  var membersChildren = <Widget>[];
  RefreshController _refreshController;

  @protected
  @mustCallSuper
   void initState() {
    super.initState();
    WidgetsBinding.instance
      .addPostFrameCallback((_) {
        _createRoomWidget(); 
        _createMemberWidget();
      });
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose(){
    _refreshController.dispose();
    super.dispose();
  }

  Widget _scrollableCardWidget() {
    return Card(
      elevation: 10.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 10.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: membersChildren
          ),
        ),
      ),
    );
  }

  Widget _contentWidget() {
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
            child: new Wrap(
              runSpacing: 10.0,
              spacing: 10.0,
              children: roomsChildren
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

  void _createRoomWidget() {
    for (var room in rooms){
      setState(() {
        roomsChildren.add(
          new Room(room['name'], room['noOfDevices'])
        );
      });
    }
  }

  void _createMemberWidget() {
    for (var member in members) {
      setState(() {
        membersChildren.add(
          new Member(member['name'], member['status'])
        );
      });
    }
  }

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 100));

    if(rooms.length != roomsChildren.length) {
      roomsChildren.clear();
      _createRoomWidget();
    }

    if(members.length != membersChildren.length){
      membersChildren.clear();
      _createMemberWidget();
    }
    
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
            body: Stack(
              children: <Widget>[
                Container(height: MediaQuery.of(context).size.height/2, width: MediaQuery.of(context).size.width, child: new Image(image: new AssetImage("assets/images/house.jpg"), fit: BoxFit.cover)),
                new SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: new SingleChildScrollView(
                    child: new Center(
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 35.0),
                            child: new AppBar(
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
                ),
              ]
            )
          );
  }
}

class Member extends StatelessWidget {
  final String name;
  final String status;
  
  Member(this.name,this.status);

  @override
  Widget build(BuildContext context) {
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
}

class Room extends StatelessWidget {
  final String name;
  final String noOfDevices;
  
  Room(this.name, this.noOfDevices);

  @override
  Widget build(BuildContext context) {
    Widget _getIcon(name) {
      switch (name) {
        case "Bathroom":
          return new Icon(MdiIcons.shower, size: 50, color: Color.fromRGBO(0, 76, 153, 0.6),);
        case "Bedroom":
          return new Icon(MdiIcons.bedKingOutline, size: 50, color: Color.fromRGBO(0, 76, 153, 0.6),);
        case "Garage":
          return new Icon(MdiIcons.garage, size: 50, color: Color.fromRGBO(0, 76, 153, 0.6),);
        case "Kitchen":
          return new Icon(MdiIcons.stove, size: 40, color: Color.fromRGBO(0, 76, 153, 0.6),);
        default:
          return new Icon(MdiIcons.sofa, size: 40, color: Color.fromRGBO(0, 76, 153, 0.6),);
      }
    }

    return GestureDetector(
      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => RoomPage(name)));},
      child: new Card(
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
                        _getIcon(name),
                      ],
                    ),
                  ),
                  new Text(name, style: Theme.of(context).textTheme.display3,),
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
      ),
    );
  }
}