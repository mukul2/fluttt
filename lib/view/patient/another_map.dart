import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsDemo extends StatefulWidget {
  @override
  State createState() => MapsDemoState();
}

class MapsDemoState extends State<MapsDemo> {
  final Set<Marker> _markers = {};
  final FocusNode _focusNode = FocusNode();
  OverlayEntry _overlayEntry;
  bool _isLabelOn = false;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      } else {
        this._overlayEntry.remove();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
        builder: (context) => Positioned(
          left: 200.0,
          top: 500.0,
          width: 100.0,
          child: Material(
            elevation: 4.0,
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: <Widget>[
                Text('bingo! this works')
              ],
            ),
          ),
        ));
  }

  void _onAddMarkerButtonPressed() {
    print('in _onAddMarkerButtonPressed()');
    setState(() {
      _isLabelOn = true;

      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("111"),
        position: LatLng(30.666, 76.8127),
        infoWindow: InfoWindow(
          title: "bingo! This works",
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("111"),
        position: LatLng(30.666, 77.8127),
        infoWindow: InfoWindow(
          title: " 2bingo! This works",
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("111"),
        position: LatLng(31.666, 76.8127),
        infoWindow: InfoWindow(
          title: " 3bingo! This works",
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });


    print('setState() done');
  }

  GoogleMapController mapController;
  //Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);import 'package:permission_handler/permission_handler.dart';

  Widget textLabel() {
    if (_isLabelOn) {
      return TextFormField(
        focusNode: this._focusNode,
        decoration: InputDecoration(labelText: 'Vehicle'),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height-200.0,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition:
                CameraPosition(target: LatLng(30.666, 76.8127), zoom: 15),
              ),
            ),
            CompositedTransformTarget(
                link: this._layerLink,
                child: textLabel()
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          print('in fab()');
          double mq1 = MediaQuery.of(context).devicePixelRatio;

          _onAddMarkerButtonPressed();

          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(30.666, 76.8127),
                zoom: 15.0,
              ),
            ),
          );
        }));
  }
}