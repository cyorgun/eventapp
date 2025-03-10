import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

import 'package:evente/evente.dart';
import 'package:http/http.dart' as http;

class UpdateEventDetailScreen extends StatefulWidget {
  String? id;
  Event? event;
   UpdateEventDetailScreen({super.key,this.event,this.id});

  @override
  State<UpdateEventDetailScreen> createState() => _UpdateEventDetailScreenState();
}

class _UpdateEventDetailScreenState extends State<UpdateEventDetailScreen> {
 CreateEventController controller = Get.put(CreateEventController());
  String dropdownvalue = 'swimming';
  String dropdownvalue2 = 'trending';
  
 int _latitude = 0;
  var items = ['swimming',"game", "football","comedy","konser","trophy","tour","festival","study","party","olympic","cultrure"
  ];
  var items2 = ['trending', "feature", "popular"];

  _onPictureSelection1() async {
    controller.getImage1();
  }

  _onPictureSelection2() async {
    controller.getImage2();
  }

  String? imageUrl;

  bool loading = false;

  var formKey = GlobalKey<FormState>();
  File? imageFile;
  String? fileName;

  var dateCtrl = TextEditingController();
  var descCtrl = TextEditingController();
  var locCtrl = TextEditingController();
  var priceCtrl = TextEditingController();
  var titleCtrl = TextEditingController();
  var typeCtrl = TextEditingController();
  var timeCtrl = TextEditingController();

  // final Completer<GoogleMapController> _controller = Completer();

  final Completer<GoogleMapController> _controller = Completer();
  LatLng? currentPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  var markerIdCounter = 0;
  final TextEditingController _controllerNamaLokasi = TextEditingController();
  var _controllerLatitude = TextEditingController();
  var _controllerLongitude = TextEditingController();

  String markerIdVal({bool increment = false}) {
    String val = 'marker_id_$markerIdCounter';
    if (increment) markerIdCounter++;
    return val;
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    Geolocator.getCurrentPosition().then((value) {
      setState(() {
        currentPosition = LatLng(40.730610, -73.935242);
        if (currentPosition != null) {
          MarkerId markerId = MarkerId(markerIdVal());
          LatLng position = currentPosition!;
          Marker marker = Marker(
            markerId: markerId,
            position: position,
            draggable: false,
          );
          markersgm(markerId, marker);

          Future.delayed(
            const Duration(seconds: 1),
            () async {
              GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: position,
                    zoom: 10.0,
                  ),
                ),
              );
            },
          );
        }
      });
    });
  }

  
  void sendNotification(String title, String body) async {
 
    List<String> allTokens = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("UserTokens").get();
snapshot.docs.forEach((doc) {
   Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  if (data != null) {
    String token = data['token'];

    allTokens.add(token);
    
  }
print(allTokens);
  // setState(() {
  //   allTokens.add(token);
  // });
});


        // Send notification to each FCM token
    for (String token in allTokens) {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAe6Ts2VU:APA91bELeOqnREA-0yruuVPGCIEgZESZ7_iFK7LNqFMHUGIHT9VmuKaISotsAZfagEok5QNndb6O3D6eoPQ7V-VFq_MTyOhj6zOYfeLBiMC1kd1IixGtz1t54e7weACj-T8epfHb4Je9',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,

            },
            'priority': 'high',
            'data': 
            // [
              
            // ],
             <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to":token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }}
  }
 

  void markersgm(MarkerId markerId, Marker updateMarker) {
    markers[markerId] = updateMarker;
    print(markers);
    setState(() {
      
    _controllerLatitude.text = updateMarker.position.latitude.toString();
    _controllerLongitude.text = updateMarker.position.longitude.toString();
    });
    // update();
  }

  Future pickImage() async {
    final _imagePicker = ImagePicker();
    //var imagepicked = await _imagePicker.getImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    var imagepicked = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1080, maxWidth: 920);

    if (imagepicked != null) {
      setState(() {
        imageFile = File(imagepicked.path);
        fileName = (imageFile!.path);
      });
    } else {
      print('No image selected!');
    }
  }
   void _onLatitudeTextChanged() {
    setState(() {
      _latitude = int.tryParse(_controllerLatitude.text) ?? 0;
    });
  }

  Future uploadPicture() async {

    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('Pictures/${DateTime.now()}');
    UploadTask uploadTask = storageReference.putFile(imageFile!);

    await uploadTask.whenComplete(() async {
      var _url = await storageReference.getDownloadURL();
      var _imageUrl = _url.toString();
      setState(() {
        imageUrl = _imageUrl;
      });
    });
  }

 


  handleUpdateData() async {

    DateTime chosenDate = DateFormat('dd/MM/yyyy').parse(dateCtrl.text);
    Timestamp timestamp = Timestamp.fromDate(chosenDate);
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'No internet',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
   
          imageFile == null
              ? await FirebaseFirestore.instance
                  .runTransaction((Transaction transaction) async {
                  SharedPreferences prefs;
                  prefs = await SharedPreferences.getInstance();
                  FirebaseFirestore.instance.collection("event").doc(widget.id).update({
                    "category": dropdownvalue.toString(),
                    "date": timestamp,
                    "time": timeCtrl.text,
                    "description": descCtrl.text,
                    "id":  DateTime.now().toString(),
                    "image": imageUrl,
                    "location": locCtrl.text,
                    "latLng": GeoPoint(
                        double.tryParse(_controllerLatitude.text) ?? 0.0,
                        double.tryParse(_controllerLongitude.text) ?? 0.0),
                    'createdAt': FieldValue.serverTimestamp(),
                    "loves": "",
                      "mapsLangLink":num.tryParse(_controllerLongitude.text)??0.0,
                      "mapsLatLink": num.tryParse(_controllerLatitude.text)??0.0,
                    'count': 0,
                    "price": int.tryParse(priceCtrl.text) ?? 0,
                    "title": titleCtrl.text,
                    "type": dropdownvalue2.toString(),
                    "userDesc": "Organizer",
                    "userName": "Admin",
                    "userProfile": "https://firebasestorage.googleapis.com/v0/b/evente-pro.appspot.com/o/5546667.png?alt=media&token=d27e22fa-8461-4755-b54a-f00b9dd3abd2"
                  });
                }).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        'Update Event Success',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                  
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                  setState(() => loading = false);
                })
              : await uploadPicture().then((value) => FirebaseFirestore.instance
                      .runTransaction((Transaction transaction) async {
                    SharedPreferences prefs;
                    prefs = await SharedPreferences.getInstance();
                    FirebaseFirestore.instance.collection("event").doc(widget.id).update({
                      "category": dropdownvalue.toString(),
                      "date": timestamp,
                      "time": timeCtrl.text,
                      'createdAt': FieldValue.serverTimestamp(),
                      "description": descCtrl.text,
                      "id":  DateTime.now().toString(),
                      "image": imageUrl,
                      "location": locCtrl.text,
                      "loves": "",
                      'count': 0,
                      "mapsLangLink":num.tryParse(_controllerLongitude.text)??0.0,
                      "mapsLatLink": num.tryParse(_controllerLatitude.text)??0.0,
                      "price": int.tryParse(priceCtrl.text) ?? 0,
                      "title": titleCtrl.text,
                      "type": dropdownvalue2.toString(),
                      "userDesc": "Organizer",
                      "userName": "Admin",
                      "userProfile":"https://firebasestorage.googleapis.com/v0/b/evente-pro.appspot.com/o/5546667.png?alt=media&token=d27e22fa-8461-4755-b54a-f00b9dd3abd2"
                    });
                  }).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        'Update Event Success',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                    setState(() => loading = false);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  
                    //        ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     backgroundColor: Colors.blue,
                    //     content: Text(
                    //       'Update Success',
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // );
  
                  
                  }));
        
      }
    });
  }

  void permission() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
  }

  @override
  void initState() {
    // TODO: implement initState
     DateTime? dateTime = widget.event?.date?.toDate();
    String date = DateFormat('dd/MM/yyyy').format(dateTime!);
    
      dateCtrl.text = date??'';
      timeCtrl.text = widget.event?.time??'';
      descCtrl.text = widget.event?.description??'';
      imageUrl = widget.event?.image??'';
      locCtrl.text = widget.event?.location??'';
      _controllerLatitude.text = widget.event?.mapsLatLink.toString()??'';
      _controllerLongitude.text = widget.event?.mapsLangLink.toString()??'';; 
      priceCtrl.text = widget.event?.price.toString()??'';
      titleCtrl.text = widget.event?.title??'';
      dropdownvalue = widget.event?.category??'';
      dropdownvalue2 = 'trending';
      imageFile = null;
    permission();
   onMapCreated;
   _onLatitudeTextChanged;
    _controllerLatitude.addListener(_onLatitudeTextChanged);
    Geolocator.getCurrentPosition().then((value) {
      setState(() {
        currentPosition = LatLng(40.730610, -73.935242);
      });
    });
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {

bool isButtonDisabled = true;
    if (titleCtrl.text == "" ||
    imageFile == null ||
        descCtrl.text == "" ||
        locCtrl.text == "" ||
        priceCtrl.text == "" ||
        dateCtrl.text == "" ||
        timeCtrl.text == "" ||
        _controllerLatitude.text == "" ||
        _controllerLongitude.text == "") {
      isButtonDisabled = true;
    }
    // int? intValue = int.tryParse(_controllerLatitude.text);
    //

num intValue = num.tryParse(_controllerLatitude.text)??0.0;
    return Scaffold(
      appBar: buildAppBar(),
      body: Form(
        key: formKey,
        child: Column(
          children: [
          //   if(intValue==null)Text("null"),
            
          // Text("Latitude: $intValue"??''),

          // Text("Latitude2:" + num.tryParse(_controllerLatitude.text).toString()??''),
          
            Divider(color: dividerColor, thickness: 1, height: 1),
            Expanded(
                flex: 1,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  primary: true,
                  shrinkWrap: true,
                  children: [
                    getVerSpace(20),
                    // buildImageWidget(),
                    GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: GetBuilder<CreateEventController>(
                        init: CreateEventController(),
                        builder: (controller) => imageFile == null
                            ? Container(
                                height: 155,
                                decoration: BoxDecoration(
                                    color: lightColor,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                           widget.event?.image??''),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(22)),
                                child: DottedBorder(
                                    dashPattern: const [6, 6],
                                    color: accentColor,
                                    strokeWidth: 1,
                                    radius: Radius.circular(22),
                                    borderType: BorderType.RRect,
                                    child: Container()
                        
                              ))
                            : Container(
                                height: 155,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    image: DecorationImage(
                                        image: FileImage(imageFile!),
                                        fit: BoxFit.cover)),
                              ),
                      ),
                    ),

                    getVerSpace(20),
                    getCustomFont("Enter event title", 16, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5),
                    getVerSpace(4),
                    getDefaultTextFiledWithLabel(
                        context, "Enter event title", titleCtrl,
                        isEnable: false, height: 60),
                    getVerSpace(20),
                    getCustomFont("Event Category", 16, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5),
                    getVerSpace(4),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: borderColor, width: 1)),
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.center,
                      child: DropdownButton(
                        value: dropdownvalue,
                        underline: Container(),
                        isDense: true,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            fontFamily: Constant.fontsFamily),
                        icon:Icon(Icons.arrow_drop_down),
                        isExpanded: true,
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                    ),
        
                    getVerSpace(20),
              
                    getCustomFont("Enter Description", 16, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5),
                    getVerSpace(4),
                    getDefaultTextFiledWithLabel(
                        context, "Enter description", descCtrl,
                        isEnable: false, height: 60, minLines: true),
                    // getVerSpace(20),
                    // getCustomFont("Event Type", 16, Colors.black, 1,
                    //     fontWeight: FontWeight.w600, txtHeight: 1.5),
                    // getVerSpace(4),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: GestureDetector(
                    //       onTap: () {
                    //         controller.onChange(0.obs);
                    //       },
                    //       child: Container(
                    //         height: 60,
                    //         decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             border: Border.all(color: borderColor, width: 1),
                    //             borderRadius: BorderRadius.circular(22)),
                    //         padding: EdgeInsets.only(left: 18),
                    //         child: Row(
                    //           children: [
                    //             GetX<CreateEventController>(
                    //               builder: (controller) => getSvgImage(
                    //                   controller.select.value == 0
                    //                       ? "checkRadio.svg"
                    //                       : "uncheckRadio.svg",
                    //                   width: 24,
                    //                   height: 24),
                    //               init: CreateEventController(),
                    //             ),
                    //             getHorSpace(10),
                    //             getCustomFont(
                    //                 "Private event", 16, Colors.black, 1,
                    //                 fontWeight: FontWeight.w500)
                    //           ],
                    //         ),
                    //       ),
                    //     )),
                    //     getHorSpace(20),
                    //     Expanded(
                    //         child: GestureDetector(
                    //       onTap: () {
                    //         controller.onChange(1.obs);
                    //       },
                    //       child: Container(
                    //         height: 60,
                    //         decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             border: Border.all(color: borderColor, width: 1),
                    //             borderRadius: BorderRadius.circular(22)),
                    //         padding: EdgeInsets.only(left: 18),
                    //         child: Row(
                    //           children: [
                    //             GetX<CreateEventController>(
                    //               builder: (controller) => getSvgImage(
                    //                   controller.select.value == 1
                    //                       ? "checkRadio.svg"
                    //                       : "uncheckRadio.svg",
                    //                   width: 24,
                    //                   height: 24),
                    //               init: CreateEventController(),
                    //             ),
                    //             getHorSpace(10),
                    //             getCustomFont(
                    //                 "Public event", 16, Colors.black, 1,
                    //                 fontWeight: FontWeight.w500)
                    //           ],
                    //         ),
                    //       ),
                    //     ))
                    //   ],
                    // ),

                    getVerSpace(20),
                    getCustomFont("Price", 16, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5),
                    getVerSpace(4),
                    TextFormField(
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: Constant.fontsFamily),
                      decoration: InputDecoration(
                          hintText: 'Enter Price',
                          labelText: 'Price',
                          counter: Container(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: accentColor, width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: errorColor, width: 1)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: errorColor, width: 1)),
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              fontFamily: Constant.fontsFamily),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1)),
                          suffixIconConstraints: BoxConstraints(
                            maxHeight: 24,
                          ),
                          hintStyle: TextStyle(
                              color: greyColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: Constant.fontsFamily)),
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value!.isEmpty) return "price can't be empty";
                        return null;
                      },
                      // onChanged: (String value){
                      //   setState(() {
                      //     email = value;
                      //   });
                      // },
                    ),
                    // getDefaultTextFiledWithLabel(
                    //     context, "Enter price", priceCtrl,
                    //     isEnable: false, height: 60),
                    getVerSpace(20),
                    getCustomFont("Date", 16, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5),
                    getVerSpace(4),
                    getDefaultTextFiledWithLabel(
                        context, "Select date", dateCtrl,
                        isEnable: true,
                        height: 60,
                        withSufix: true,
                        suffiximage: 'calender_black.svg', onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: accentColor,
                                ),
                               
                              ),
                              child: child!);
                        },
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                        setState(() {
                          dateCtrl.text = formattedDate;
                        });

                        // controller.onDateChange(formattedDate.obs);
                      } else {}
                    }, isReadonly: true),
                    getVerSpace(20),
                    getCustomFont("Time", 16, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5),
                    getVerSpace(4),
                    Row(
                      children: [
                        Expanded(
                          child: getDefaultTextFiledWithLabel(
                              context, "Start time", timeCtrl,
                              isEnable: false,
                              height: 60,
                              isReadonly: true, onTap: () async {
                            TimeOfDay? timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              initialEntryMode: TimePickerEntryMode.dial,
                            );
                            if (timeOfDay != null) {
                              final now = DateTime.now();
                              var startTime = DateTime(now.year, now.month,
                                  now.day, timeOfDay.hour, timeOfDay.minute);
                              final format = DateFormat.jm();
                              setState(() {
                                timeCtrl.text = format.format(startTime);
                              });
                              // controller
                              //     .onStartTimeChange(format.format(startTime).obs);
                            }
                          }),
                        ),
                        // getHorSpace(20),
                        // Expanded(
                        //   child: getDefaultTextFiledWithLabel(
                        //       context, "End time", controller.endTimeController,
                        //       isEnable: false,
                        //       height: 60,
                        //       isReadonly: true, onTap: () async {
                        //     TimeOfDay? timeOfDay = await showTimePicker(
                        //       context: context,
                        //       initialTime: TimeOfDay.now(),
                        //       initialEntryMode: TimePickerEntryMode.dial,
                        //     );
                        //     if (timeOfDay != null) {
                        //       final now = DateTime.now();
                        //       var startTime = DateTime(now.year, now.month, now.day,
                        //           timeOfDay.hour, timeOfDay.minute);
                        //       final format = DateFormat.jm();
                        //       controller
                        //           .onEndTimeChange(format.format(startTime).obs);
                        //     }
                        //   }),
                        // ),
                      ],
                    ),

                    getVerSpace(20),
                             getCustomFont("Venue Address", 16, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5),
                    getVerSpace(4),
                    getDefaultTextFiledWithLabel(
                        context, "Enter address", locCtrl,
                        isEnable: false, height: 60, minLines: true),
                    getVerSpace(20),
         getCustomFont("Choose Location Address", 16, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5),
                    getVerSpace(10),
                                 Stack(
                                   children: [
                                     SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * .4,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          // target:  currentPosition == null? const LatLng(-6.1753924, 106.8249641): LatLng(currentPosition!.latitude, currentPosition!.longitude),
                         target: LatLng(widget.event?.mapsLatLink??40.730610, widget.event?.mapsLangLink??-73.935242),
                          zoom: 10,
                        ),
                        markers: Set<Marker>.of(markers.values),
                        onMapCreated: onMapCreated,
                        
                        onCameraMove: (position) {
                          setState(() {
      _controllerLatitude.text = position.target.latitude.toString();
      _controllerLongitude.text = position.target.longitude.toString();
    });
  
                          if (markers.values.isNotEmpty) {
                            MarkerId markerId = MarkerId(markerIdVal());
                            Marker? marker = markers[markerId];
                            Marker updatedMarker = marker!.copyWith(
                              positionParam: position.target,
                            );
                            setState(() {
                              markersgm(markerId, updatedMarker);
                            });
                          }
                        },
                        zoomControlsEnabled: false,
                        zoomGesturesEnabled: true,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * .17),
                        child: Icon(Icons.location_on, color: Colors.red, size: 30,),
                      )),
                                   ],
                                 ),
         
                    getVerSpace(20),
         getCustomFont("Latitude", 16, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5),
                    getVerSpace(5),
                      TextFormField(
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: Constant.fontsFamily),
                      decoration: InputDecoration(
                          hintText: 'Latitude',
                          
                          counter: Container(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          isDense: true,prefixIcon:  Icon(Icons.multiple_stop),
                          filled: true,  
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: accentColor, width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: errorColor, width: 1)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: errorColor, width: 1)),
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              fontFamily: Constant.fontsFamily),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1)),
                          suffixIconConstraints: BoxConstraints(
                            maxHeight: 24,
                          ),
                          hintStyle: TextStyle(
                              color: greyColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: Constant.fontsFamily)),
                      controller: _controllerLatitude,
                      
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value!.isEmpty) return "Latitude can't be empty";
                        return null;
                      },
                      // onChanged: (String value){
                      //   setState(() {
                      //     email = value;
                      //   });
                      // },
                    ),
                    getVerSpace(10),
                    
         getCustomFont("Longitude", 16, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5),
                    getVerSpace(5),
                                 TextFormField(
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          fontFamily: Constant.fontsFamily),
                      decoration: InputDecoration(
                          hintText: 'Longitude',
                          
                          counter: Container(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          isDense: true,prefixIcon:  Icon(Icons.multiple_stop),
                          filled: true,  
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: accentColor, width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: errorColor, width: 1)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: errorColor, width: 1)),
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              fontFamily: Constant.fontsFamily),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1)),
                          suffixIconConstraints: BoxConstraints(
                            maxHeight: 24,
                          ),
                          hintStyle: TextStyle(
                              color: greyColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: Constant.fontsFamily)),
                      controller: _controllerLongitude,
                      
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value!.isEmpty) return "Longitude can't be empty";
                        return null;
                      },
                      // onChanged: (String value){
                      //   setState(() {
                      //     email = value;
                      //   });
                      // },
                    ),
         
                 
                  
                   getVerSpace(30),

                    loading == true
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          )
                        : getButton(
                            context, accentColor, "Update Event", Colors.white, () {
                                   showDialog(context: context, builder: (context){
                  return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(37 ),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20 ),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          getVerSpace(30 ),
          Container(
            width: double.infinity,
            height: 190 ,
            margin: EdgeInsets.symmetric(horizontal: 30 ),
            decoration: BoxDecoration(
              color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(34 ))),
            child: Column(
              children: [
                getVerSpace(40 ),  
               Icon(Icons.error,size: 120.0,color: Colors.red,),
              
           ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30 ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(37 ),
                boxShadow: [
                  BoxShadow(
                      color: "#2B9CC3C6".toColor(),
                      offset: const Offset(0, -2),
                      blurRadius: 24)
                ]),
            child: Column(
              children: [
                getVerSpace(30 ),
                getCustomFont('This Feature Not Abble', 22 , Colors.black, 1,
                    fontWeight: FontWeight.w700, txtHeight: 1.5 ),
                getVerSpace(8 ),
                getMultilineCustomFont(
                    "This Feature Ready on Release APK.", 16 , Colors.black,
                    fontWeight: FontWeight.w500, txtHeight: 1.5 ),
                getVerSpace(30 ),
                getButton(context, Colors.redAccent, "Close", Colors.white, () {
                     Navigator.pop(context);
                }, 18 ,
                    weight: FontWeight.w700,
                    buttonHeight: 60 ,
                    borderRadius: BorderRadius.circular(22 )),
                getVerSpace(30 ),
              ],
            ),
          )
        ],
      ),
    );
              
                  });


             
                          
                            // handleUpdateData();
                          }, 18,
                            weight: FontWeight.w700,
                            borderRadius: BorderRadius.circular(22),
                            buttonHeight: 60),
                    getVerSpace(50),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
  
    return getToolBar(() {
      Navigator.of(context).pop();
    },
        title: getCustomFont('Update Event', 20, Colors.black, 1,
            fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        leading: true,
        
        
        );
  }
}
