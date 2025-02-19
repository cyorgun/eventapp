import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ModalTicket {
  String? eventId;
  String? title;
  int? price;
  int? ticketCount;
  Timestamp? date;

  ModalTicket(
      {this.eventId, this.title, this.price, this.ticketCount, this.date});

  factory ModalTicket.fromFirestore(DocumentSnapshot snapshot, double distance) {
    Map data = snapshot.data() as Map<dynamic, dynamic>;

    return ModalTicket(
        eventId: data['eventId'],
        title: data['eventTitle'],
        price: data['price'],
        ticketCount: data['ticketCount'],
        date: data['timestamp']);
  }
}
