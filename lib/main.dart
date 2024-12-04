import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';


void main() {
  runApp( const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {



  final _mapStyle = """
    [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]
      """;
  final kGoogleApiKey = "AIzaSyAnDy5hfpzcS8UP_4ZrwuRNtDaUuVIAn58";



  late GoogleMapController mapController;
  LatLng? location;
  Location? coordinates;


  Map<MarkerId, Marker> markers = {};

  PolylinePoints polylinePoints = PolylinePoints();

  Map<PolylineId, Polyline> polylines = {};



  Completer<GoogleMapController> _controller = Completer();

  TextEditingController _textEditingController = TextEditingController();


  @override
  void initState() {
    /// add origin marker origin marker

    super.initState();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(36.70447, 3.08267),
    zoom: 13,
  );





  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex!,
                  myLocationEnabled: true,
                  polylines: Set<Polyline>.of(polylines.values),
                  markers: Set<Marker>.of(markers.values),
                  onMapCreated: (GoogleMapController controller) async{
                    location = (await LocationData());
                    _controller.complete(controller);
                    controller.setMapStyle(_mapStyle);
                  },
                ),
            ),

             Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  width: 70,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  child: const Icon(Icons.my_location,color: Colors.orange,)),
                ),
             Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  width: 70,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  child: const Icon(Icons.notifications,color: Colors.orange,)),
                ),
             Positioned(
                top: 60,
                left: 20,
                right: 20,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap:() async{
                                 print("\n \n \n \nclicked");

                                  SearchPlace();



                                 },
                        child:  TextFormField(
                          decoration:const InputDecoration(
                              enabled: false,
                              prefixIcon: Icon(Icons.location_searching,color: Colors.white,),
                              hintText: "Enter your destination",
                              hintStyle: TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.w500)
                          ),

                        ),
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        controller: _textEditingController,
                        onTap: () {

                        },
                        decoration:const InputDecoration(
                            prefixIcon: Icon(Icons.my_location,color: Colors.white,),
                            enabled: false,
                            hintText: "Enter your depart",
                            hintStyle: TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.w500)
                        ),
                      ),
                    ],
                  )
                ),

            )
          ],
        ),




    );
  }

  Future<LatLng> LocationData() async{
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permission denied');
    }

    Position userPosition = await Geolocator.getCurrentPosition();

    // Create a variable to store the user's position coordinates
    return LatLng(userPosition.latitude,userPosition.longitude);
  }

  void SearchPlace() async{

    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

     Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: (error){},
      mode: Mode.fullscreen, // or Mode.fullscreen
      language: 'fr',
      components: [Component(Component.country, 'dz')],
    );




     if (p != null) {
       // Get the coordinates of the selected place
       PlacesDetailsResponse placeDetails = await places.getDetailsByPlaceId(p.placeId.toString());
        coordinates = placeDetails.result.geometry?.location;
        LatLng destination = LatLng(coordinates!.lat,coordinates!.lng);

       final BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
         ImageConfiguration(devicePixelRatio: 2.0),
         'assets/circle.png',
       );

       final BitmapDescriptor fromIcon = await BitmapDescriptor.fromAssetImage(
         ImageConfiguration(devicePixelRatio: 2.0),
         'assets/circle_one.png',
       );

       _addMarker(
         location!,
         "origin",
         fromIcon,

       );

       // Add destination marker
       _addMarker(
         destination,
         "destination",
          markerIcon,
       );

       _getPolyline(location!,destination!);

       var distance = haversineDistance(location!, destination) * 31;

       _textEditingController.text = distance.toInt().toString();




     }
  }






  /// this is my new

  void _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  void _getPolyline(LatLng from,LatLng to) async {

    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAnDy5hfpzcS8UP_4ZrwuRNtDaUuVIAn58",
      PointLatLng(from.latitude,from.longitude),
      PointLatLng(to.latitude,to.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  void _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 3,
      color: Colors.green
    );
    polylines[id] = polyline;
    setState(() {});
  }


  double haversineDistance(LatLng point1, LatLng point2) {

    const EarthRadius = 6371.01;
    final latitude1 = point1.latitude * pi / 180;
    final longitude1 = point1.longitude * pi / 180;
    final latitude2 = point2.latitude * pi / 180;
    final longitude2 = point2.longitude * pi / 180;

    final deltaLatitude = latitude2 - latitude1;
    final deltaLongitude = longitude2 - longitude1;

    final a = sin(deltaLatitude / 2) * sin(deltaLatitude / 2) +
        cos(latitude1) * cos(latitude2) * sin(deltaLongitude / 2) *
            sin(deltaLongitude / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final distance = EarthRadius * c;

    return distance;
  }


}

