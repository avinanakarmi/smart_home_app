import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class RoomPage extends StatefulWidget {
  final String room;

  RoomPage(this.room);

  @override
  _RoomPageState createState() => _RoomPageState(room);
}

class _RoomPageState extends State<RoomPage> with SingleTickerProviderStateMixin{
  final String room;
  String backgroundImagePath;
  TabController _tabController;
  RefreshController _refreshController;

  _RoomPageState(this.room) {
    switch (this.room) {
      case "Bathroom":
        backgroundImagePath = "assets/images/bathroom.jpg";
        break;
      case "Bedroom":
        backgroundImagePath = "assets/images/bedroom.jpg";
        break;
      case "Garage":
        backgroundImagePath = "assets/images/garage.jpg";
        break;
      case "Kitchen":
        backgroundImagePath = "assets/images/kitchen.jpg";
        break;
      default:
        backgroundImagePath = "assets/images/livingRoom.jpg";
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: devices.length, vsync: this);
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  List devices = [
    {"name":"Lights", "status":"Off"},
    {"name":"Temperature", "status":"25"},
    {"name":"Router", "status":"On"},
    {"name":"Coffee Maker", "status":"On"},
    {"name":"Refrigirator", "status":"Off"},
  ];

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  Icon _getDeviceIcon (String deviceName) {
    Icon deviceIcon;
    switch (deviceName) {
      case "Temperature":
        deviceIcon = new Icon(MdiIcons.thermometer);
        break;
      case "Coffee Maker":
        deviceIcon = new Icon(MdiIcons.coffee);
        break;
      case "Router":
        deviceIcon = new Icon(Icons.wifi);
        break;
      case "Refrigirator":
        deviceIcon = new Icon(MdiIcons.fridgeOutline);
        break;
      default:
        deviceIcon = new Icon(Icons.lightbulb_outline);
    }
    return deviceIcon;
  }

  Widget _createDeviceTab(Map<String, String> device) {
    if(device["name"] == "Temperature"){
      return new Column(
        children: <Widget>[
          new Icon(MdiIcons.speedometer),
          new GestureDetector(child: new Text(device["status"]))
        ],
      );
    } else if(device["name"] == "Lights") {
      return new Column(
        children: <Widget>[
          device["status"]=="On" ? new Icon(MdiIcons.lightbulbOnOutline, size: 150.0, color: Colors.white70,) : new Icon(MdiIcons.lightbulbOffOutline, size: 150.0, color: Colors.white70,),
          new Text(device["status"], style: TextStyle(color: Colors.white70, fontSize: 20.0),)
        ],
      );
    } else if(device["name"] == "Router") {
      return new Column(
        children: <Widget>[
          device["status"]=="On" ? new Icon(Icons.wifi, size: 150.0, color: Colors.white70,) : new Icon(MdiIcons.wifiOff, size: 150.0, color: Colors.white70,),
          new Text(device["status"], style: TextStyle(color: Colors.white70, fontSize: 20.0),)
        ],
      );
    } else {
      return new Column(
        children: <Widget>[
          device["status"]=="On" ? new Icon(MdiIcons.toggleSwitchOutline, size: 150.0, color: Colors.white70,) : new Icon(MdiIcons.toggleSwitchOffOutline, size: 150.0, color: Colors.white70,),
          new Text(device["status"], style: TextStyle(color: Colors.white70, fontSize: 20.0),)
        ],
      );
    }   
  }

  @override
  Widget build(BuildContext context) {
    return new SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: new SingleChildScrollView(
        child: new Container(
          height: 500,
          width: 500,
          decoration: new BoxDecoration(
            image: DecorationImage(image: AssetImage(backgroundImagePath), fit: BoxFit.cover)
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: new Scaffold(
              backgroundColor: Colors.transparent,
              appBar: new AppBar(
                title: new Text(this.room),
                centerTitle: true,
                leading: new GestureDetector(child: new Icon(Icons.chevron_left), onTap: () => Navigator.of(context).pop(),),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(58.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: CircleTabIndicator(color: Colors.white, radius: 2),
                      tabs: devices.map((device) {
                        return Tab(
                          text: device["name"],
                          icon: _getDeviceIcon(device["name"]),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              body: new Column(
                children: <Widget>[
                  Expanded(
                    child: new TabBarView(
                      controller: _tabController,
                      children: devices.map((device) {
                        return new Container(
                          height: MediaQuery.of(context).size.height/2,
                          padding: EdgeInsets.all(50.0),
                          child: GestureDetector(child: _createDeviceTab(device), onTap: () {
                              if (device["name"] != "Temperature"){
                                setState(() {
                                  device["status"] = device["status"] == "On" ? "Off" : "On"; 
                                });
                              }
                            },
                          ),
                        );
                      }).toList()
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
      )
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius}) : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset = offset + Offset(cfg.size.width / 2, cfg.size.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}