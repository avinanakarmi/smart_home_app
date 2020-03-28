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

  List<Map<String, String>> devices = [
    {"name":"Lights", "status":"off"},
    {"name":"Temperature", "status":"25"},
    {"name":"Router", "status":"on"},
    {"name":"Coffee Maker", "status":"on"},
    {"name":"Chimney", "status":"off"},
    {"name":"Refrigirator", "status":"on"},
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
        deviceIcon = new Icon(Icons.router);
        break;
      case "Refrigirator":
        deviceIcon = new Icon(MdiIcons.iceCream);
        break;
      case "Chimney":
        deviceIcon = new Icon(MdiIcons.fireplace);
        break;
      default:
        deviceIcon = new Icon(Icons.lightbulb_outline);
    }
    return deviceIcon;
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
          child: new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              title: new Text(this.room),
              centerTitle: true,
              leading: new GestureDetector(child: new Icon(Icons.chevron_left), onTap: () => Navigator.of(context).pop(),),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50.0),
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
            body: new Column(
              children: <Widget>[
                Expanded(
                  child: new TabBarView(
                    controller: _tabController,
                    children: devices.map((device) {
                      return new Container(
                        height: MediaQuery.of(context).size.height/2,
                        padding: EdgeInsets.all(25.0),
                        // child: DeviceTab (device),
                        child: new Text(device["status"]),
                      );
                    }).toList()
                  ),
                ),
              ]
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

class DeviceTab extends StatelessWidget {
  final Map<String, String> device;

  DeviceTab(this.device);

  Widget _deviceStatusWidget() {
    if(device["name"] == "Temperature"){
      return new Column(
        children: <Widget>[
          new Icon(Icons.dashboard),
          new Text(device["status"])
        ],
      );
    } else {
      IconData icon;
      switch (device["status"]) {
        case "on":
          icon = Icons.lightbulb_outline;
          break;
        default:
      }
      return new Column(
        children: <Widget>[
          new Icon(icon),
          new Text(device["status"])
        ],
      );
    }    
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _deviceStatusWidget(),
    );
  }
}