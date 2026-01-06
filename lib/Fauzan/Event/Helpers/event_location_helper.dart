import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../Services/location_services.dart';
import '../Utils/location_dialog.dart';
import '../EventDataList/event_constants.dart';

class EventLocationHelper {
  static Future<String?> detectProvince(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final agreed = await showLocationDialog(context);
    if (!agreed) return null;

    final granted = await LocationService.requestPermission();
    if (!granted) return null;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) return null;

    final rawProvince = placemarks.first.administrativeArea ?? '';
    final normalized = normalizeProvince(rawProvince);

    return provinces.contains(normalized) ? normalized : null;
  }
}
