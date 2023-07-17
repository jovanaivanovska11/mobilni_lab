import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Model/list_item.dart';
import '../Screens/notifications_screen.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';


class GoogleMapPage extends StatefulWidget {
  static const String id = "mapScreen";
  final List<ListItem> _list;
  GoogleMapPage(this._list);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState(_list);
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final NotificationService service = NotificationService();
  final List<Marker> markers = <Marker>[];
  List<ListItem> _list;
  Map<PolylineId, Polyline> polylines = {};
  Completer<GoogleMapController> _controller = Completer();

  _GoogleMapPageState(this._list);

  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(42.00478491557928, 21.40917442067392),
    zoom: 14.4746,
  );

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("Error$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _createMarkers(_list);
  }


  void _shortestDistance(LatLng userLocationCoordinates, LatLng destinationLocationCoordinates) async{
    PolylinePoints polylinePoints = PolylinePoints();
    String googleAPI = 'AIzaSyDbDd-BgNIfxCKSCkzsMM2sDzrRDtpb7N8';

    addPolyLine(List<LatLng> polylineCoordinates) {
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.pink,
        points: polylineCoordinates,
        width: 8,
      );
      polylines[id] = polyline;
      setState(() {});
    }

    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPI,
      PointLatLng(userLocationCoordinates.latitude, userLocationCoordinates.longitude),
      PointLatLng(destinationLocationCoordinates.latitude, destinationLocationCoordinates.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }


  void _createMarkers(_list) {
    for (var i = 0; i < _list.length; i++) {
      print(_list[i].course);
      markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position:
          LatLng(_list[i].location.latitude, _list[i].location.longitude),
          infoWindow: InfoWindow(
            title: _list[i].course,
            snippet:
            DateFormat("yyyy-MM-dd HH:mm:ss").format(_list[i].date),
          ),
          icon: BitmapDescriptor.defaultMarker,
          onTap: (){
            getUserCurrentLocation().then((value) async {
              LatLng destinationCoords = LatLng(_list[i].location.latitude, _list[i].location.longitude);
              LatLng userCoords = LatLng(value.latitude, value.longitude);
              _shortestDistance(userCoords, destinationCoords);
            });//Icon for Marker
          }
      ));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE91E63),
        title: Text("Google Map Page"),
      ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition: _kGoogle,
            markers: Set<Marker>.of(markers),
            polylines: Set<Polyline>.of(polylines.values),
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUserCurrentLocation().then((value) async {
            print(value.latitude.toString() + " " + value.longitude.toString());

            CameraPosition cameraPosition = new CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14,
            );

            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
        child: Icon(Icons.pin_drop_outlined),
      ),
    );
  }
}