import 'package:bookbuddies/models/userLocation.dart';
import 'package:bookbuddies/services/location_service.dart';
import 'package:flutter/material.dart';

enum LocationProviderStatus {
  Initial,
  Loading,
  Success,
  Error,
}

class LocationProvider with ChangeNotifier {
  UserLocation _userLocation = UserLocation(0, 0);
  LocationServices _locationServices = LocationServices();

  LocationProviderStatus _status = LocationProviderStatus.Initial;

  Future<void> getLocation() async {
    try {
      _updateStatus(LocationProviderStatus.Loading);

      _userLocation = await _locationServices.getCurrentLocation();

      _updateStatus(LocationProviderStatus.Success);
    } catch (e) {
      _updateStatus(LocationProviderStatus.Error);
    }
  }

  UserLocation get userLocation => _userLocation;

  LocationProviderStatus get status => _status;

  void _updateStatus(LocationProviderStatus status) {
    if (_status != status) {
      _status = status;
      notifyListeners();
    }
  }
}
