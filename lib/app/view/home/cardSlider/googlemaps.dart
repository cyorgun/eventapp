import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsWidget extends StatefulWidget {
  final double latitude;
  final double longitude;

  MapsWidget({required this.latitude, required this.longitude});

  @override
  _MapsWidgetState createState() => _MapsWidgetState();
}

class _MapsWidgetState extends State<MapsWidget> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.latitude, widget.longitude),
        zoom: 15,
      ),
      onMapCreated: (controller) {
        setState(() {
          mapController = controller;
        });
      },
      markers: Set<Marker>.of([
        Marker(
          markerId: MarkerId('marker'),
          position: LatLng(widget.latitude, widget.longitude),
          infoWindow: InfoWindow(
            title: 'Lokasi',
            snippet: 'Lokasi Terpilih',
          ),
        ),
      ]),
    );
  }
}