import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectedLocationModel {
  Placemark? address;
  LatLng? latLng;

  SelectedLocationModel({this.address,this.latLng});

  SelectedLocationModel.fromJson(Map<String, dynamic> json) {
    final addressMap = json['address'];
    if (addressMap != null) {
      address = Placemark(
        name: addressMap['name'],
        street: addressMap['street'],
        isoCountryCode: addressMap['isoCountryCode'],
        country: addressMap['country'],
        postalCode: addressMap['postalCode'],
        administrativeArea: addressMap['administrativeArea'],
        subAdministrativeArea: addressMap['subAdministrativeArea'],
        locality: addressMap['locality'],
        subLocality: addressMap['subLocality'],
        thoroughfare: addressMap['thoroughfare'],
        subThoroughfare: addressMap['subThoroughfare'],
      );
    }
    final latLngJson = json['latLng'];
    if (latLngJson != null) {
      if (latLngJson is Map) {
        latLng = LatLng(latLngJson['latitude'], latLngJson['longitude']);
      } else if (latLngJson is List && latLngJson.length == 2) {
        latLng = LatLng(latLngJson[0], latLngJson[1]);
      }
    }
  }

  String getFullAddress() {
    if (address == null) return "No address selected";
    return "${address!.street}, ${address!.subLocality}, ${address!.locality}, ${address!.administrativeArea}, ${address!.country}";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address == null
        ? null
        : {
      'name': address!.name,
      'street': address!.street,
      'isoCountryCode': address!.isoCountryCode,
      'country': address!.country,
      'postalCode': address!.postalCode,
      'administrativeArea': address!.administrativeArea,
      'subAdministrativeArea': address!.subAdministrativeArea,
      'locality': address!.locality,
      'subLocality': address!.subLocality,
      'thoroughfare': address!.thoroughfare,
      'subThoroughfare': address!.subThoroughfare,
    };
    data['latLng'] = latLng == null
        ? null
        : {
      'latitude': latLng!.latitude,
      'longitude': latLng!.longitude,
    };
    return data;
  }
}
