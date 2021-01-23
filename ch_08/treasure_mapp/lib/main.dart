import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dbhelper.dart';
import 'place.dart';
import 'place_dialog.dart';
import 'manage_places.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MainMap(),
    );
  }
}

class MainMap extends StatefulWidget {
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  List<Marker> markers = [];
  DbHelper helper;

  final CameraPosition position = CameraPosition(
    target: LatLng(37.2381676, 127.0708563),
    zoom: 12,
  );

  @override
  void initState() {
    helper = DbHelper();
    _getCurrentLocation().then((pos){
      addMarker(pos, 'currpos', 'You are here!');
    }).catchError(
            (err)=> print(err.toString())
    );
    // helper.insertMockData();
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('The Treasure Mapp'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              MaterialPageRoute route =
              MaterialPageRoute(builder: (context)=> ManagePlaces());
              Navigator.push(context, route);
            },
          ),
        ],
      ),
        body: Container(
        child: GoogleMap(
          initialCameraPosition: position, markers: Set<Marker>.of(markers),
        ),
      ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_location),
          onPressed: () {
            int here = markers.indexWhere((p)=> p.markerId == MarkerId('currpos'));
            Place place;
            if (here == -1) {
//the current position is not available
              place = Place(0, '', 0, 0, '');
            }
            else {
              LatLng pos = markers[here].position;
              place = Place(0, '', pos.latitude, pos.longitude, '');
            }
            PlaceDialog dialog = PlaceDialog(place, true);
            showDialog(
                context: context,
                builder: (context) =>
                    dialog.buildDialog(context)
            );
          },
        )
    );
  }

  Future _getCurrentLocation() async {
    bool isGeolocationAvailable = await Geolocator.isLocationServiceEnabled();

    Position _position = Position(latitude: this.position.target.latitude,
        longitude: this.position.target.longitude);
    if (isGeolocationAvailable) {
      try {
        _position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
      }
      catch (error) {
        return _position;
      }
    }
    return _position;
  }

  void addMarker(Position pos, String markerId, String markerTitle )
  {
    final marker = Marker(
        markerId: MarkerId(markerId),
        position: LatLng(pos.latitude, pos.longitude),
        infoWindow: InfoWindow(title: markerTitle),
        icon: (markerId=='currpos') ?
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
            :BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
    );
    markers.add(marker);
    setState(() {
      markers = markers;
    });
  }

  Future _getData() async {
    await helper.openDb();
// await helper.testDb();
    List <Place> _places = await helper.getPlaces();
    for (Place p in _places) {
      addMarker(Position(latitude: p.lat, longitude: p.lon),
          p.id.toString(), p.name);
    }
    setState(() {
      markers = markers;
    });

  }
}
