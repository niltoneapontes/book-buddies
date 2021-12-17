import 'dart:async';
import 'dart:math';

import 'package:bookbuddies/models/userLocation.dart';
import 'package:bookbuddies/providers/location_provider.dart';
import 'package:bookbuddies/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

const double cameraZoom = 20;
const double cameraTilt = 50;
const double cameraBearing = 30;

class MapWidget extends StatefulWidget {
  final List<Circle> circles;
  final List<Marker> markers;

  const MapWidget({Key? key, required this.circles, required this.markers})
      : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late Position position;
  late GoogleMapController mapControler;
  Completer<GoogleMapController> _controller = Completer();
  late Set<Circle> _circles = this.widget.circles.toSet();
  late Set<Marker> _markers = this.widget.markers.toSet();

  @override
  void dispose() {
    LocationServices().closeLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, LocationProvider provider, _) {
        if (provider.status == LocationProviderStatus.Loading ||
            provider.status == LocationProviderStatus.Initial) {
          return Center(child: CircularProgressIndicator());
        } else if (provider.status == LocationProviderStatus.Success) {
          var locationProvider = Provider.of<UserLocation>(context);
          CameraPosition initialCameraPosition = CameraPosition(
            zoom: cameraZoom,
            target:
                LatLng(locationProvider.latitude, locationProvider.longitude),
          );

          return Stack(children: [
            GoogleMap(
              initialCameraPosition: initialCameraPosition,
              myLocationEnabled: true,
              mapToolbarEnabled: true,
              buildingsEnabled: false,
              compassEnabled: true,
              rotateGesturesEnabled: true,
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              markers: _markers,
              circles: _circles,
              onLongPress: (argument) {},
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ]);
        } else {
          return Center(child: Text("We can't reach your location"));
        }
      }),
    );
  }
}
