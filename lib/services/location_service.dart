import 'dart:async';

import 'package:bookbuddies/models/userLocation.dart';
import 'package:geolocator/geolocator.dart';

class LocationServices {
  late UserLocation userLocation;
  late Position _currentLocation;

  Geolocator geolocator = Geolocator();
  late StreamSubscription<Position> positionStream;

  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationServices() {
    positionStream = Geolocator.getPositionStream().listen((location) {
      _locationController
          .add(UserLocation(location.latitude, location.longitude));
    });
  }

  void closeLocation() {
    if (positionStream != null) {
      positionStream.cancel();

      _locationController.close();

      positionStream = null as StreamSubscription<Position>;
    } else {}
  }

  Future<UserLocation> getCurrentLocation() async {
    try {
      var isServiceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!isServiceEnabled) {
        isServiceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!isServiceEnabled) {
          throw Exception("The Location service is disabled!");
        }
      }

      var isPermission = await Geolocator.checkPermission();
      if (isPermission == LocationPermission.denied ||
          isPermission == LocationPermission.deniedForever) {
        isPermission = await Geolocator.requestPermission();
      }
      if (isPermission == LocationPermission.denied ||
          isPermission == LocationPermission.deniedForever) {
        throw Exception("Location Permission requests has been denied!");
      }

      if (isServiceEnabled &&
          (isPermission == LocationPermission.always ||
              isPermission == LocationPermission.whileInUse)) {
        _currentLocation = await Geolocator.getCurrentPosition().timeout(
          Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException(
                "Location information could not be obtained within the requested time.");
          },
        );
        userLocation =
            UserLocation(_currentLocation.latitude, _currentLocation.longitude);
        return userLocation;
      } else {
        throw Exception("Location Service requests has been denied!");
      }
    } on TimeoutException catch (_) {
      print(_);
      throw _;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
