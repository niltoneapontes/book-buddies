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
  const MapWidget({Key? key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late Position position;
  late GoogleMapController mapControler;
  Completer<GoogleMapController> _controller = Completer();
  late Set<Marker> _markers = {};

  void animatedViewofMap({required double lat, required double lng}) async {
    CameraPosition cPosition = CameraPosition(
      zoom: cameraZoom,
      target: LatLng(lat, lng),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

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
              target: LatLng(
                  locationProvider.latitude, locationProvider.longitude));

          animatedViewofMap(
              lat: locationProvider.latitude, lng: locationProvider.longitude);

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
              onLongPress: (argument) {
                _markers.add(new Marker(
                    markerId: MarkerId(Random().nextInt(1000).toString()),
                    position: argument));
              },
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
