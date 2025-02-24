import 'package:latlong2/latlong.dart';

class ContactLocationModel {
  late String title;
  late String map;
  late String wa;
  late String tg;
  late LatLng lng;

  ContactLocationModel({required this.title, required this.map, required this.wa, required this.tg, required this.lng});
}