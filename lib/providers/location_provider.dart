import 'package:bookbuddies/models/userLocation.dart';
import 'package:bookbuddies/services/location_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

enum LocationProviderStatus {
  Initial,
  Loading,
  Success,
  Error,
}

class LocationProvider with ChangeNotifier {
  late UserLocation _userLocation;
  LocationServices _locationServices = LocationServices();

  LocationProviderStatus _status = LocationProviderStatus.Initial;

  UserLocation get userLocation => _userLocation;

  LocationProviderStatus get status => _status;

  Future<void> getLocation() async {
    try {
      _updateStatus(LocationProviderStatus.Loading);

      _userLocation = await _locationServices.getCurrentLocation();

      _updateStatus(LocationProviderStatus.Success);
    } catch (e) {
      _updateStatus(LocationProviderStatus.Error);
    }
  }

  void _updateStatus(LocationProviderStatus status) {
    if (_status != status) {
      developer
          .log('LocationProvider: Status updated from: $_status to: $status');
      _status = status;
      notifyListeners();
    }
  }
}
