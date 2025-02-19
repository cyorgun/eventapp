import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventBaru {
  String? category;
  Timestamp? date;
  String? description;
  String? id;
  String? location;
  double? mapsLangLink;
  double? mapsLatLink;
  int? price;
  String? title;
  String? type;
  String? userDesc;
  String? userName;
  String? time;
  String? userProfile;
  String? image;
  int? count;
  int? capacity;
  int? join;
  LatLng? latLng;
  List<dynamic>? joinEvent;
  String? typePayment;
  double? distance;

  EventBaru(
      {this.category,
      this.date,
      this.description,
      this.joinEvent,
      this.id,
      this.location,
      this.time,
      this.mapsLangLink,
      this.mapsLatLink,
      this.typePayment,
      this.price,
      this.title,
      this.type,
      this.userDesc,
      this.userName,
      this.join,
      this.image,
      this.count,
      this.latLng,
      this.distance,
      this.userProfile,
      this.capacity});

  factory EventBaru.fromFirestore(DocumentSnapshot snapshot, double distance) {
    Map data = snapshot.data() as Map<dynamic, dynamic>;

    LatLng latLng = LatLng(data['mapsLatLink'], data['mapsLangLink']);
    return EventBaru(
        category: data['category'],
        date: data['date'],
        image: data['image'],
        description: data['description'],
        id: snapshot.id,
        latLng: latLng,
        count: data['count'],
        location: data['location'],
        typePayment: data['typePayment'],
        time: data['time'],
        mapsLangLink: data['mapsLangLink'],
        mapsLatLink: data['mapsLatLink'],
        price: data['price'],
        title: data['title'],
        type: data['type'],
        join: data['join'],
        userDesc: data['userDesc'],
        userName: data['userName'],
        userProfile: data['userProfile'],
        capacity: data['capacity'],
        joinEvent: data['joinEvent'] ?? [],
        distance: distance);
  }
}
