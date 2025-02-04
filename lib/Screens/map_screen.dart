import 'package:decereix/Provider/cat_provider.dart';
import 'package:decereix/Screens/loading.dart';
import 'package:decereix/Screens/show_map_leaflet.dart';
import 'package:decereix/models/trajectories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static double sizeImage = 10; int initialTime = 86400;
  List<List<Marker>> markerStackSMR = [];
  List<List<Marker>> markerStackMLAT = [];
  List<List<Marker>> markerStackADSB = [];
  int lengthMarker = 0;
  Future<bool> computePoints(List<Trajectories> SMRTrajectories, List<Trajectories> MLATTrajectories,
      List<Trajectories> ADSBTrajectories, int initialTime, int endTime) {
    /*List<List<Marker>> markersStack = [];*/

    List<Marker> markersSMR = [];
    List<Marker> markersMLAT = [];
    List<Marker> markersADSB = [];

    for (int currTime = initialTime; currTime < (endTime + 1); currTime++) {
      SMRTrajectories.forEach((element) {
        // List Time pick the latest
        int k = element.ListTime.lastIndexWhere(
                (element) => ((element < (currTime + 1))&& (element > (currTime -1))));
        if (k != -1) {
          if (element.type == 2) {
            markersSMR.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Tooltip(
                message:  "SMR & ${element.Target_Identification??" "}",
                child: Transform.rotate(
                  angle: element.ListAngles[k],
                  child:  Icon(
                    Icons.airplanemode_active,
                    color: Colors.black87,
                    size: sizeImage*2,
                    semanticLabel: "SMR & ${element.Target_Identification??" "}", //For Accessibility
                  ),
                ),
              ),
            ));
          } else if (element.type == 1) {
            markersSMR.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Icon(
                Icons.local_car_wash_rounded,
                color: Colors.black87,
                size: sizeImage,
                semanticLabel: element.Target_Identification ?? element.Target_Address, //For Accessibility
              ),
            ));
          } else {
            markersSMR.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Icon(
                Icons.grade,
                color: Colors.black87,
                size: sizeImage,
                semanticLabel: element.Target_Identification ?? element.Target_Address, //For Accessibility
              ),
            ));
          }
        }
      });
      MLATTrajectories.forEach((element) {
        // List Time pick the latest
        int k = element.ListTime.lastIndexWhere(
                (element) => ((element < (currTime + 1))&& (element > (currTime -1))));
        if (k != -1) {
          if (element.type == 2) {
            markersMLAT.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Tooltip(
                message: "MLAT & ${element.Target_Identification??" "}",
                child: Transform.rotate(
                  angle: element.ListAngles[k],
                  child:  Icon(
                    Icons.airplanemode_active,
                    color: Colors.redAccent,
                    size: sizeImage*2,
                    semanticLabel: "MLAT & ${element.Target_Identification??" "}", //For Accessibility
                  ),
                ),
              ),
            ));
          } else if (element.type == 1) {
            markersMLAT.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Icon(
                Icons.local_car_wash_rounded,
                color: Colors.redAccent,
                size: sizeImage,
                semanticLabel: element.Target_Identification ?? element.Target_Address, //For Accessibility
              ),
            ));
          } else {
            markersMLAT.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Icon(
                Icons.grade,
                color: Colors.redAccent,
                size: sizeImage,
                semanticLabel: element.Target_Identification ?? element.Target_Address, //For Accessibility
              ),
            ));
          }
        }
      });
      ADSBTrajectories.forEach((element) {
        // List Time pick the latest
        int k = element.ListTime.lastIndexWhere(
                (element) => ((element < (currTime + 1))&& (element > (currTime -1))));
        if (k != -1) {
          if (element.type == 2) {
            markersADSB.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Tooltip(
                message: "ADS-B & ${element.Target_Identification??" "}",
                child: Transform.rotate(
                  angle: element.ListAngles[k],
                  child:  Icon(
                    Icons.airplanemode_active,
                    color: Colors.blueAccent,
                    size: sizeImage*2,
                    semanticLabel: "ADS-B & ${element.Target_Identification??" "}", //For Accessibility
                  ),
                ),
              ),
            ));
          } else if (element.type == 1) {
            markersADSB.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Icon(
                Icons.local_car_wash_rounded,
                color: Colors.blueAccent,
                size: sizeImage,
                semanticLabel: element.Target_Identification ?? element.Target_Address, //For Accessibility
              ),
            ));
          } else {
            markersADSB.add(new Marker(
              width: 10.0,
              height: 10.0,
              point: element.ListPoints[k],
              builder: (ctx) => Icon(
                Icons.grade,
                color: Colors.blueAccent,
                size: sizeImage,
                semanticLabel: element.Target_Identification ?? element.Target_Address, //For Accessibility
              ),
            ));
          }
        }
      });
      markerStackSMR.add(markersSMR);
      markerStackMLAT.add(markersMLAT);
      markerStackADSB.add(markersADSB);
      markersSMR=[];
      markersMLAT=[];
      markersADSB=[];
    }
    return Future.value(true);
  }


  @override
  Widget build(BuildContext context) {
    CatProvider _catProvider = Provider.of<CatProvider>(context, listen: true);

    /// [_fetchPreferences] We fetch the preference from the storage and notify in future
    Future< bool> _fetchMarkers() async {
      try{
        if(!_catProvider.hasMarkers){
        // Time
        initialTime = _catProvider.firstTime; //Units seconds[s]
        bool stat = await computePoints(_catProvider.smrTrajectories,_catProvider.mlatTrajectories,_catProvider.adsbTrajectories, initialTime, _catProvider.endTime);
        _catProvider.markerStackSMR = this.markerStackSMR;
        _catProvider.markerStackMLAT = this.markerStackMLAT;
        _catProvider.markerStackADSB = this.markerStackADSB;
        _catProvider.hasMarkers = true;
        debugPrint("Fetch Cat All");
        }
        else{
          /*this.markerStackSMR = _catProvider.markerStackSMR ;
          this.markerStackMLAT = _catProvider.markerStackMLAT;
          this.markerStackADSB = _catProvider.markerStackADSB;*/
        }
        return true;
      }
      catch(e){
        return false;
      }
    }
    //--------------------List of Trajectories--------------------------//
    final getFutureBuildWidget = FutureBuilder<bool>(
      future: _fetchMarkers(),
      builder: (context, snapshot1) {
        switch (snapshot1.connectionState) {
          case ConnectionState.none:

            /// Show [ErrorScreen], as we are unable to get the response...
            return Text("Cannot Retrieve Trajectories...");
          case ConnectionState.waiting:

            /// Show [LoadingScreen], as we are waiting for the response...
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: 'Loading, please have patience ...',
                          style: TextStyle(fontStyle: FontStyle.italic,
                              fontSize: 36)),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: '¿Tu sabías que las cajas negras de'
                          ' los aviones en realidad son naranjas?',
                          style: TextStyle(fontWeight:FontWeight.bold)),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: '- Que me dices! ¿no son cajas?',
                          style: TextStyle(fontWeight:FontWeight.bold)),
                    ],
                  ),
                ),

              ],
            ),);
          default:
            if (snapshot1.hasError) {
              /// Show [ErrorScreen], as we got a error
              return Text(
                snapshot1.error.toString(),
              );
            } else {
              /// Show [Map] with trajectories for current time
              if(snapshot1.data){
                return ShowMapLeaflet(
                  lengthMarkerStack: _catProvider.endTime, markerStackSMR:  _catProvider.markerStackSMR, markerStackMLAT:  _catProvider.markerStackMLAT, markerStackADSB:  _catProvider.markerStackADSB,);
              }else{
                return Container(
                  child: Text("Error: Could not load trajectory!"),
                );
              }
            }
        }
      },
    );

    return getFutureBuildWidget;
  }
}
