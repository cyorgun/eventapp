import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/services.dart' show rootBundle;

import '../../../../base/color_data.dart';
import '../../../modal/modal_event.dart';
import '../../featured_event/featured_event_detail2.dart';
import '../cardSlider/cardSlider.dart';
import '../cardSlider/lokasimodel.dart';

class MapsScreenT1 extends StatefulWidget {
  MapsScreenT1({Key? key}) : super(key: key);

  @override
  _MapsScreenT1State createState() => _MapsScreenT1State();
}

class _MapsScreenT1State extends State<MapsScreenT1> {
  late GoogleMapController _controller;
  BitmapDescriptor? customIcon;
  bool isMapCreated = false;
  // List<Marker> allMarkers = [];

  List<Marker> allMarkers  = [];
  PageController? _pageController;
   List<DocumentSnapshot> dataList = [];

   
  List<Map<dynamic, dynamic>> dataList2 = [];
  
  final firestoreInstance = FirebaseFirestore.instance;
  // List<DocumentSnapshot> dataList = [];

  int? prevPage;


  @override
  void initState() {
    // TODO: implement initState
    // rootBundle.loadString('assets/Template1/map_style.txt').then((string) {
    //   _mapStyle = string;
    // });
    // FirebaseFirestore.instance.collection('event')
    // .get()
    // .then((querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     Map<String, dynamic> data = doc.data();

    //     allMarkers.add(Marker(
    //       icon:
    //           BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    //       markerId: MarkerId(data['title']),
    //       draggable: false,
    //       infoWindow:
    //           InfoWindow(title: data['title'], snippet: data['location']),
    //       position: LatLng(data['mapsLangLink'].latitude as double,
    //           data['mapsLatLink'].longitude as double),
    //     ));
    //   });
    // });
FirebaseFirestore.instance
        .collection('event')
        .get()
        .then(( querySnapshot) {
          
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data();
        LatLng latLng = LatLng(data['mapsLatLink'], data['mapsLangLink']);
        // LatLng(40.7078523, -74.008981)
        Marker marker = Marker(
          markerId: MarkerId(doc.id),
          position: latLng,
          infoWindow: InfoWindow(
            title: data['title'],
            snippet: data['location'],
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        );
          
        markers.add(marker);
         });

      
    });
    // getMarker();
    getDataFromFirestore();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
      
    super.initState();
  }

  Set<Marker> markers = Set<Marker>();

  void getMarker() {
    firestoreInstance.collection("event").get().then((querySnapshot) {
      setState(() {
        dataList2.clear();
        Map<dynamic, dynamic> values = querySnapshot.docs.map((doc) {
          return doc.data();
        }).toList() as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          dataList2.add(value);
        });
      });
    });
  }
 

  void _onScroll() {
    if (_pageController!.page!.toInt() != prevPage) {
      prevPage = _pageController!.page!.toInt();
      moveCamera();
    }
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

   void getDataFromFirestore() {
    FirebaseFirestore.instance.collection("event").get().then((querySnapshot) {
      setState(() {
        dataList.clear();
        dataList.addAll(querySnapshot.docs);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // if (isMapCreated) {
    //   getJsonFile("assets/nightmode.json").then(setMapStyle);
    // }
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: LatLng(40.7078523, -74.008981), zoom: 13.0),

                // markers: markers,
                onTap: (pos) {
                  print(pos);
                  Marker m = Marker(
                      markerId: MarkerId('1'),
                      icon: customIcon!,
                      position: pos);
                  setState(() {
                    markers.add(m);
                  });
                },
                markers:
                    Set.from(markers),
                    //                {
                    // Marker(
                    //   markerId: const MarkerId("marker1"),
                    //   position:  LatLng(40.7078523, -74.008981),
                    //   draggable: true,
                    //   onDragEnd: (value) {
                    //     // value is the new position
                    //   },
                    //   // To do: custom marker icon
                    // ),},

                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
              ),
            ),
          dataList.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          :  Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return cardMaps(index);
                  },
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Container(
                    height: 55.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 0.0),
                      child: Center(
                        child: Text(
                          "Locations",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Gilroy",
                              fontWeight: FontWeight.w700,
                              fontSize: 22.0,),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: <Color>[
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.6),
                        Colors.white,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: coffeeShops[_pageController!.page!.toInt()].locationCoords!,
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  Widget cardMaps(index) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('event').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final List<Event> lokasiList = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
          final events = snapshot.data?.docs.map((e) {
            return Event.fromFirestore(e);
          }).toList();
            return Event(
           category : data['category'],
    date  : data['date'],
    image: data['image'],
    description  : data['description'],
    id  : data['id'],
    location  : data['location'],
    mapsLangLink  : data['mapsLangLink'],
    mapsLatLink  : data['mapsLatLink'],
    price  : data['price'],
    title  : data['title'],
    type  : data['type'],
    userDesc  : data['userDesc'],
    userName  : data['userName'],
    userProfile  : data['userProfile'],
            );
            // return Event.fromFirestore(events);
          }).toList();
          // return CardSlider(lokasiList: lokasiList);
          return AnimatedBuilder(
              animation: _pageController!,
              builder: (
                BuildContext context,
                Widget? widget,
              ) {
                // ignore: unused_local_variable

                double value = 1;
                if (_pageController!.position.haveDimensions) {
                  value = _pageController!.page! - index;
                  value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
                }
                return Center(
                  child: SizedBox(
                    height: Curves.easeInOut.transform(value) * 125.0,
                    width: Curves.easeInOut.transform(value) * 350.0,
                    child: widget,
                  ),
                );
              },
              child: card(lokasiList, index));
        });
  }

  Widget card(lokasiList, i) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 0.0, right: 8.0, top: 5.0, bottom: 5.0),
      child: InkWell(
        onTap: () {
           Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => FeaturedEvent2Detail(
                    event:lokasiList[i],
                        // category: category,
                        // date: date,
                        // description: description,
                        // id: id,
                        // image: image,
                        // location: location,
                        // mapsLangLink: mapsLangLink,
                        // mapsLatLink: mapsLatLink,
                        // price: price,
                        // title: title,
                        // type: type,
                        // userDesc: userDesc,
                        // userName: userName,
                        // userProfile: userProfile,
                      )));
        },
        child: Container(
          height: 140.0,
          width: 340.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    color: Colors.black12.withOpacity(0.03))
              ]),
          child: Row(
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: Container(
                  height: 140.0,
                  width: 110.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          bottomLeft: Radius.circular(15.0)),
                      image: DecorationImage(
                          image: NetworkImage(lokasiList[i].image ?? ''),
                          fit: BoxFit.cover)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5.0,),
                    Container(
                        width: 150.0,
                        child: Text(
                          lokasiList[i].title ?? '',
                          style: TextStyle(
                              fontFamily: "Gilroy",
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 17.0),
                          overflow: TextOverflow.ellipsis,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 13.0,
                            color: Colors.black,
                          ),
                          SizedBox(width: 5.0,),
                          Container(
                            width: 140.0,
                            child: Text(
                              lokasiList[i].location ?? '',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.5,
                                  fontFamily: "Gilroy",
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Container(
                      height: 35.0,
                      width: 80.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          color: accentColor),
                      child: Center(
                          child: Text(
                        lokasiList[i].category ?? '',
                        style: TextStyle(color: Colors.white),
                      )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
