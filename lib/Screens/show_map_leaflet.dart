import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
const double pi = 3.1415;
class ShowMapLeaflet extends StatefulWidget {
  final LatLng location;
  const ShowMapLeaflet({Key key, @required this.location}) : super(key: key);

  @override
  _ShowMapLeafletState createState() => _ShowMapLeafletState();
}

class _ShowMapLeafletState extends State<ShowMapLeaflet> {

  /// [logger] to logg all of the logs in console prettily!
  List<LatLng> tappedPoints = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var markers = [
      new Marker(
        width: 60.0,
        height: 60.0,
        point: widget.location,
        builder: (ctx) => Transform.rotate(
          angle: 180 * pi / 180,
          child: Icon(
            Icons.airplanemode_active,
            color: Colors.red,
            size: 42.0,
            semanticLabel: 'Marker Placed on Map', //For Accessibility
          ),
        ),
      )
    ];
    return SafeArea(
      child: Scaffold(
        body: FlutterMap(
          options: new MapOptions(
            center: widget.location,
            zoom: 12.0,
            maxZoom: 18.0,
            minZoom: 7.0,
          ),
          layers: [
            new TileLayerOptions(
                keepBuffer: 150,
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
            new MarkerLayerOptions(
              markers: markers,
            ),
          ],
        ),
      ),
    );
  }
}
