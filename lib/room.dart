import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RoomPage extends StatefulWidget {
  final String room;

  RoomPage(this.room);

  @override
  _RoomPageState createState() => _RoomPageState(room);
}

class _RoomPageState extends State<RoomPage> with SingleTickerProviderStateMixin{
  final String room;
  String backgroundImagePath;

  List devices = [
    {"name":"Lights", "status":"Off"},
    {"name":"Temperature", "status":"35", "currentRoomTemp" : "20"},
    {"name":"Router", "status":"On"},
    {"name":"Coffee Maker", "status":"On"},
    {"name":"Refrigirator", "status":"Off"},
  ];
  
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
                          child: GestureDetector(child: new DeviceTab(device), onTap: () {
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

class DeviceTab extends StatelessWidget {
  final Map<String, String> device;

  DeviceTab(this.device);

  @override
  Widget build(BuildContext context) {
    if(device["name"] == "Temperature"){
      return new Column(
        children: <Widget>[
          new TemperatureMonitor(device["status"]=="Off" ? "0" : device["status"]),
          new Text("Current Temperature : " + device["currentRoomTemp"] + "℃", style: TextStyle(color: Colors.white70, fontSize: 15),)
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
}

class TemperatureMonitor extends StatefulWidget {
  final String acSetTo;

  TemperatureMonitor(this.acSetTo);

  @override
  _TemperatureMonitorState createState() => _TemperatureMonitorState(acSetTo);
}

class _TemperatureMonitorState extends State<TemperatureMonitor> {
  final String acSetTo;

  _TemperatureMonitorState(this.acSetTo);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      padding: EdgeInsets.only(top: 15),
      child: SfRadialGauge(
        axes: <RadialAxis>[
          new RadialAxis(
            minimum: 0, 
            maximum: 100, 
            labelOffset: 30,
            startAngle: 170,
            endAngle: 10,
            radiusFactor: 1.2,
            showLabels: false,
            axisLineStyle: AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor,
              thickness: 0.03, 
              gradient: const SweepGradient(
                colors: <Color>[Colors.transparent, Colors.blue, Colors.white, Colors.red, Colors.transparent],
                stops: <double>[0.0, 0.25, 0.50, 0.75, 1]
            ),
              cornerStyle: CornerStyle.bothCurve),
            majorTickStyle: MajorTickStyle(length: 0),
            minorTickStyle: MinorTickStyle(length: 0),
            pointers: <GaugePointer>[
              MarkerPointer(
                value: double.parse(acSetTo),
                markerType: MarkerType.circle,
                color: Color.fromRGBO(0, 76, 153, 0.8),
                borderColor: Color.fromRGBO(255, 255, 255, 0.8),
                borderWidth: 2,
                markerHeight: 10,
                markerWidth: 10,
                enableAnimation: true, 
                animationDuration: 1500,
                enableDragging: true,
              )
            ],
            annotations: <GaugeAnnotation> [
              GaugeAnnotation(
                widget: Container(
                  child: Text(acSetTo + "℃",style: TextStyle(fontSize: 40, color: Color.fromRGBO(255, 255, 255, 0.8)))
                ),
                angle: double.parse(acSetTo)
              )
            ]
          ),
          new RadialAxis(
            showAxisLine: false,
            showLabels: false,
            startAngle: 170,
            endAngle: 10,
            majorTickStyle: MajorTickStyle(length: 10, color: Color.fromRGBO(255, 255, 255, 0.3)),
            minorTickStyle: MinorTickStyle(length: 10, color: Color.fromRGBO(255, 255, 255, 0.3)),
            interval: 2,
            radiusFactor: 1.05
          )
        ]
      ),
    );
  }
}