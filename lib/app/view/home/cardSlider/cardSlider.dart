import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/view/home/cardSlider/lokasimodel.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'googlemaps.dart';

class CardSlider extends StatelessWidget {
  final List<Lokasi> lokasiList;

  CardSlider({required this.lokasiList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Swiper(
        itemCount: lokasiList.length,
        itemWidth: 300,
        layout: SwiperLayout.DEFAULT,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  child: MapsWidget(
                    latitude: lokasiList[index].latitude,
                    longitude: lokasiList[index].longitude,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    lokasiList[index].nama,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FirebaseWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('event').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        final List<Lokasi> lokasiList = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Lokasi(
            nama: data['title'],
            latitude: data['mapsLatLink'],
            longitude: data['mapsLangLink'],
          );
        }).toList();
        return CardSlider(lokasiList: lokasiList);
      },
    );
  }
}

class MyApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Google Maps dengan Card Slider')),
        body: Center(
          child: FirebaseWidget(),
        ),
      ),
    );
  }
}

