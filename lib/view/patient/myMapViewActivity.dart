import 'dart:async';

import 'package:appxplorebd/view/patient/sharedData.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_helper.dart';
import 'map_marker.dart';

class HomePageMapCl extends StatefulWidget {
  List<LatLng> sharedMarkerLocations;
  List<String> imgLinks;
  LatLng currentLocation;

  HomePageMapCl(this.sharedMarkerLocations, this.currentLocation);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageMapCl> {
  final Completer<GoogleMapController> _mapController = Completer();

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 12;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  // final String _markerImageUrl = 'https://imagevars.gulfnews.com/2020/01/28/Sunny-Leone-_16fec6f398a_medium.jpg';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  /// Example marker coordinates
//  final List<LatLng> _markerLocations = [
//    LatLng(41.147125, -8.611249),
//    LatLng(41.145599, -8.610691),
//    LatLng(41.145645, -8.614761),
//    LatLng(41.146775, -8.614913),
//    LatLng(41.146982, -8.615682),
//    LatLng(41.140558, -8.611530),
//    LatLng(41.138393, -8.608642),
//    LatLng(41.137860, -8.609211),
//    LatLng(41.138344, -8.611236),
//    LatLng(41.139813, -8.609381),
//  ];
  final String _baseUrl_image = "http://telemedicine.drshahidulislam.com/";

  /// Called when the Google Map widget is created. Updates the map loading state
  /// and inits the markers.
  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    final List<MapMarker> markers = [];
    //  for (LatLng markerLocation in widget.sharedMarkerLocations)

    for (int i = 0; i < widget.sharedMarkerLocations.length; i++) {
      final BitmapDescriptor markerImage =
          // await MapHelper.getMarkerImageFromUrl(_baseUrl_image+ALL_HOME_DOC_LIST[i]["photo"]);
          await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

      MapMarker mk = MapMarker(
          id: widget.sharedMarkerLocations
              .indexOf(widget.sharedMarkerLocations[i])
              .toString(),
          position: widget.sharedMarkerLocations[i],
          icon: markerImage,
          title: ALL_HOME_DOC_LIST[i]["name"]);

      markers.add(mk);
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors around you'),
      ),
      body: Stack(
        children: <Widget>[
          // Google Map widget
          Opacity(
            opacity: _isMapLoading ? 0 : 1,
            child: GoogleMap(
              mapToolbarEnabled: false,
              initialCameraPosition: CameraPosition(
                target: new LatLng(ALL_HOME_DOC_LIST[0]["home_lat"], ALL_HOME_DOC_LIST[0]["home_log"]),
                zoom: _currentZoom,
              ),
              markers: _markers,
              onMapCreated: (controller) => _onMapCreated(controller),
              onCameraMove: (position) => _updateMarkers(position.zoom),
            ),
          ),

          // Map loading indicator
          Opacity(
            opacity: _isMapLoading ? 1 : 0,
            child: Center(child: CircularProgressIndicator()),
          ),

          // Map markers loading indicator
          if (_areMarkersLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Card(
                  elevation: 2,
                  color: Colors.grey.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      'Loading',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void showThisToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
