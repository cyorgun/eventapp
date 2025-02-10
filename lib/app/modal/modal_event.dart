import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
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
  int? ticket;
  int? count;
  LatLng? latLng;

  Event(
      {this.category,
      this.date,
      this.description,
      this.id,
      this.location,
      this.time,
      this.mapsLangLink,
      this.mapsLatLink,
      this.price,
      this.title,
      this.type,
      this.userDesc,
      this.ticket,
      this.userName,
      this.image,
      this.count,
      this.latLng,
      this.userProfile});

  factory Event.fromFirestore(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map<dynamic, dynamic>;

    LatLng latLng = LatLng(data['mapsLatLink'], data['mapsLangLink']);
    return Event(
      category: data['category'],
      date: data['date'],
      image: data['image'],
      description: data['description'],
      id: data['id'],
      latLng: latLng,
      count: data['count'],
      location: data['location'],
      time: data['time'],
      mapsLangLink: data['mapsLangLink'],
      mapsLatLink: data['mapsLatLink'],
      price: data['price'],
      title: data['title'],
      type: data['type'],
      ticket: data['ticket'],
      userDesc: data['userDesc'],
      userName: data['userName'],
      userProfile: data['userProfile'],
    );
  }
}

// class Event2 {
//   String? category;
//   Timestamp? date;
//   String? description;
//   String? id;
//   String? location;
//   double? mapsLangLink;
//   double? mapsLatLink;
//   int? price;
//   String? title;
//   String? type;
//   String? userDesc;
//   String? userName;
//   String? userProfile;
//   String? image;

//   Event2(
//       {this.category,
//       this.date,
//       this.description,
//       this.id,
//       this.location,
//       this.mapsLangLink,
//       this.mapsLatLink,
//       this.price,
//       this.title,
//       this.type,
//       this.userDesc,
//       this.userName,
//       this.image,
//       this.userProfile});

//   factory Event2.fromFirestore(DocumentSnapshot snapshot){
//     Map data = snapshot.data() as Map<dynamic, dynamic>;
//     return Event2(
//        category : data['category'],
//     date  : data['date'],
//     image: data['image'],
//     description  : data['description'],
//     id  : data['id'],
//     location  : data['location'],
//     mapsLangLink  : data['mapsLangLink'],
//     mapsLatLink  : data['mapsLatLink'],
//     price  : data['price'],
//     title  : data['title'],
//     type  : data['type'],
//     userDesc  : data['userDesc'],
//     userName  : data['userName'],
//     userProfile  : data['userProfile'],
//     );
//   }
// }
