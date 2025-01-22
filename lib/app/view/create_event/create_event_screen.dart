import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:event_app/app/dialog/event_publish_dialog.dart';
import 'package:event_app/app/view/bloc/sign_in_bloc.dart';
import 'package:event_app/base/constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';

import 'package:evente/evente.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  // CreateEventController controller =Get.put(CreateEventController());
  String dropdownvalue = ('swimming').tr();
  String dropdownvalue2 = 'trending';

  int _latitude = 0;
  var items = [
    ('swimming').tr(),
    ('game').tr(),
    ('football').tr(),
    ('comedy').tr(),
    ('konser').tr(),
    ('trophy').tr(),
    ('tour').tr(),
    ('festival').tr(),
    ('study').tr(),
    ('party').tr(),
    ('olympic').tr(),
    ('culture').tr()
  ];
  var items2 = ['trending', "feature", "popular"];

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
    // Geolocator.getCurrentPosition().then((value) {
    //   setState(() {
    //     currentPosition = LatLng(40.730610, -73.935242);
    //     if (currentPosition != null) {
    //       MarkerId markerId = MarkerId(markerIdVal());
    //       LatLng position = currentPosition!;
    //       Marker marker = Marker(
    //         markerId: markerId,
    //         position: position,
    //         draggable: false,
    //       );
    //       markersgm(markerId, marker);

    //       Future.delayed(
    //         const Duration(seconds: 1),
    //         () async {
    //           GoogleMapController controller = await _controller.future;
    //           controller.animateCamera(
    //             CameraUpdate.newCameraPosition(
    //               CameraPosition(
    //                 target: position,
    //                 zoom: 10.0,
    //               ),
    //             ),
    //           );
    //         },
    //       );
    //     }
    //   });
    // });
  }

  void sendNotification(String title, String body) async {
    List<String> allTokens = [];

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("UserTokens").get();
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
            'Authorization':
                'key=AAAAe6Ts2VU:APA91bELeOqnREA-0yruuVPGCIEgZESZ7_iFK7LNqFMHUGIHT9VmuKaISotsAZfagEok5QNndb6O3D6eoPQ7V-VFq_MTyOhj6zOYfeLBiMC1kd1IixGtz1t54e7weACj-T8epfHb4Je9',
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
              "to": token,
            },
          ),
        );
      } catch (e) {
        print("error push notification");
      }
    }
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
    final SignInBloc sb = context.read<SignInBloc>();
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('Profile Pictures/${DateTime.now()}');
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
    final sb = context.read<SignInBloc>();

    DateTime chosenDate = DateFormat('dd/MM/yyyy').parse(dateCtrl.text);
    Timestamp timestamp = Timestamp.fromDate(chosenDate);
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              ('noInternet').tr(),
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();
          setState(() => loading = true);

          imageFile == null
              ? await FirebaseFirestore.instance
                  .runTransaction((Transaction transaction) async {
                  SharedPreferences prefs;
                  prefs = await SharedPreferences.getInstance();
                  FirebaseFirestore.instance.collection("event").add({
                    "category": dropdownvalue.toString(),
                    "date": timestamp,
                    "time": timeCtrl.text,
                    "description": descCtrl.text,
                    "id": sb.name ?? '' + titleCtrl.text,
                    "image": imageUrl,
                    "location": locCtrl.text,
                    "latLng": GeoPoint(
                        double.tryParse(_controllerLatitude.text) ?? 0.0,
                        double.tryParse(_controllerLongitude.text) ?? 0.0),
                    'createdAt': FieldValue.serverTimestamp(),
                    "loves": "",
                    "mapsLangLink":
                        num.tryParse(_controllerLongitude.text) ?? 0.0,
                    "mapsLatLink":
                        num.tryParse(_controllerLatitude.text) ?? 0.0,
                    'count': 0,
                    "price": int.tryParse(priceCtrl.text) ?? 0,
                    "title": titleCtrl.text,
                    "type": dropdownvalue2.toString(),
                    "userDesc": "Organizer",
                    "userName": sb.name,
                    "userProfile": sb.imageUrl
                  });
                }).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        ('uploadSuccess').tr(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );

                  setState(() => loading = false);
                })
              : await uploadPicture().then((value) => FirebaseFirestore.instance
                      .runTransaction((Transaction transaction) async {
                    SharedPreferences prefs;
                    prefs = await SharedPreferences.getInstance();
                    FirebaseFirestore.instance.collection("event").add({
                      "category": dropdownvalue.toString(),
                      "date": timestamp,
                      "time": timeCtrl.text,
                      'createdAt': FieldValue.serverTimestamp(),
                      "description": descCtrl.text,
                      "id": sb.name ?? '' + DateTime.now().toString(),
                      "image": imageUrl,
                      "location": locCtrl.text,
                      "loves": "",
                      'count': 0,
                      "mapsLangLink": double.tryParse(double.tryParse(_controllerLongitude.text)
                              !.toStringAsFixed(2) )??
                          '0.00',
                      "mapsLatLink": double.tryParse(double.tryParse(_controllerLatitude.text)
                              !.toStringAsFixed(2) )??
                          '0.00',
                      "price": int.tryParse(priceCtrl.text) ?? 0,
                      "title": titleCtrl.text,
                      "type": dropdownvalue2.toString(),
                      "userDesc": "Organizer",
                      "userName": sb.name,
                      "userProfile": sb.imageUrl
                    });
                  }).then((_) {
                    //        ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     backgroundColor: Colors.blue,
                    //     content: Text(
                    //       'Update Success',
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // );
                    sendNotification(("newEvent").tr(), titleCtrl.text);
                    Navigator.of(context).pop();
                    showDialog(
                        builder: (context) {
                          return const EventpublishDialog();
                        },
                        context: context);
                    setState(() => loading = false);
                  }));
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    onMapCreated;
    _onLatitudeTextChanged;
    _controllerLatitude.addListener(_onLatitudeTextChanged);
    // Geolocator.getCurrentPosition().then((value) {
    //   setState(() {
    //     currentPosition = LatLng(40.730610, -73.935242);
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonDisabled = false;
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

    num intValue = num.tryParse(_controllerLatitude.text) ?? 0.0;
    return Scaffold(
      appBar: buildAppBar(),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            //   if(intValue==null)Text("null"),

            // Text("Latitude: $intValue"??''),

            // Text("Latitude2:" + num.tryParse(_controllerLatitude.text).toString()??''),

            Divider(color: dividerColor, thickness: 1.h, height: 1.h),
            Expanded(
                flex: 1,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  primary: true,
                  shrinkWrap: true,
                  children: [
                    getVerSpace(20.h),
                    // buildImageWidget(),
                    GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: imageFile == null
                          ? Container(
                              height: 155.h,
                              decoration: BoxDecoration(
                                  color: lightColor,
                                  borderRadius: BorderRadius.circular(22.h)),
                              child: DottedBorder(
                                  dashPattern: const [6, 6],
                                  color: accentColor,
                                  strokeWidth: 1.h,
                                  radius: Radius.circular(22.h),
                                  borderType: BorderType.RRect,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          height: 48.h,
                                          width: 48.h,
                                          padding: EdgeInsets.all(14.h),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: accentColor,
                                                  width: 1.h),
                                              borderRadius:
                                                  BorderRadius.circular(13.h)),
                                          child: getSvgImage("add.svg",
                                              color: accentColor,
                                              width: 20.h,
                                              height: 20.h),
                                        ),
                                      ),
                                      getVerSpace(10.h),
                                      getCustomFont(("addCoverImage").tr(),
                                          15.sp, greyColor, 1,
                                          fontWeight: FontWeight.w500,
                                          txtHeight: 1.46.h),
                                    ],
                                  )),
                            )
                          : Container(
                              height: 155,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22.h),
                                  image: DecorationImage(
                                      image: FileImage(imageFile!),
                                      fit: BoxFit.cover)),
                            ),
                    ),

                    getVerSpace(20.h),
                    getCustomFont(
                        ("enterEventTitle").tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                    getVerSpace(4.h),
                    getDefaultTextFiledWithLabel(
                        context, ("enterEventTitle").tr(), titleCtrl,
                        isEnable: false, height: 60.h),
                    getVerSpace(20.h),
                    getCustomFont(
                        ("eventCategory").tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                    getVerSpace(4.h),
                    Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22.h),
                          border: Border.all(color: borderColor, width: 1.h)),
                      padding: EdgeInsets.symmetric(horizontal: 18.h),
                      alignment: Alignment.center,
                      child: DropdownButton(
                        value: dropdownvalue,
                        underline: Container(),
                        isDense: true,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.5.h,
                            fontFamily: Constant.fontsFamily),
                        icon: getSvgImage("arrow_down.svg",
                            width: 20.h, height: 20.h),
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

                    getVerSpace(20.h),

                    getCustomFont(
                        ("enterDescription").tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                    getVerSpace(4.h),
                    getDefaultTextFiledWithLabel(
                        context, ("enterDescription").tr(), descCtrl,
                        isEnable: false, height: 60.h, minLines: true),
                    // getVerSpace(20.h),
                    // getCustomFont("Event Type", 16.sp, Colors.black, 1,
                    //     fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                    // getVerSpace(4.h),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: GestureDetector(
                    //       onTap: () {
                    //         controller.onChange(0.obs);
                    //       },
                    //       child: Container(
                    //         height: 60.h,
                    //         decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             border: Border.all(color: borderColor, width: 1.h),
                    //             borderRadius: BorderRadius.circular(22.h)),
                    //         padding: EdgeInsets.only(left: 18.h),
                    //         child: Row(
                    //           children: [
                    //             GetX<CreateEventController>(
                    //               builder: (controller) => getSvgImage(
                    //                   controller.select.value == 0
                    //                       ? "checkRadio.svg"
                    //                       : "uncheckRadio.svg",
                    //                   width: 24.h,
                    //                   height: 24.h),
                    //               init: CreateEventController(),
                    //             ),
                    //             getHorSpace(10.h),
                    //             getCustomFont(
                    //                 "Private event", 16.sp, Colors.black, 1,
                    //                 fontWeight: FontWeight.w500)
                    //           ],
                    //         ),
                    //       ),
                    //     )),
                    //     getHorSpace(20.h),
                    //     Expanded(
                    //         child: GestureDetector(
                    //       onTap: () {
                    //         controller.onChange(1.obs);
                    //       },
                    //       child: Container(
                    //         height: 60.h,
                    //         decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             border: Border.all(color: borderColor, width: 1.h),
                    //             borderRadius: BorderRadius.circular(22.h)),
                    //         padding: EdgeInsets.only(left: 18.h),
                    //         child: Row(
                    //           children: [
                    //             GetX<CreateEventController>(
                    //               builder: (controller) => getSvgImage(
                    //                   controller.select.value == 1
                    //                       ? "checkRadio.svg"
                    //                       : "uncheckRadio.svg",
                    //                   width: 24.h,
                    //                   height: 24.h),
                    //               init: CreateEventController(),
                    //             ),
                    //             getHorSpace(10.h),
                    //             getCustomFont(
                    //                 "Public event", 16.sp, Colors.black, 1,
                    //                 fontWeight: FontWeight.w500)
                    //           ],
                    //         ),
                    //       ),
                    //     ))
                    //   ],
                    // ),

                    getVerSpace(20.h),
                    getCustomFont(("price").tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                    getVerSpace(4.h),
                    TextFormField(
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          fontFamily: Constant.fontsFamily),
                      decoration: InputDecoration(
                          hintText: ('enterPrice').tr(),
                          labelText: ("price").tr(),
                          counter: Container(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.h)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.h)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: accentColor, width: 1.h)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: errorColor, width: 1.h)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: errorColor, width: 1.h)),
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5.h,
                              fontFamily: Constant.fontsFamily),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.h)),
                          suffixIconConstraints: BoxConstraints(
                            maxHeight: 24.h,
                          ),
                          hintStyle: TextStyle(
                              color: greyColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              fontFamily: Constant.fontsFamily)),
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value!.isEmpty) return ('priceCant').tr();
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
                    //     isEnable: false, height: 60.h),
                    getVerSpace(20.h),
                    getCustomFont(("date").tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                    getVerSpace(4.h),
                    getDefaultTextFiledWithLabel(
                        context, ('selectDate').tr(), dateCtrl,
                        isEnable: true,
                        height: 60.h,
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
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                  ),
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
                    getVerSpace(20.h),
                    getCustomFont(('time').tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                    getVerSpace(4.h),
                    Row(
                      children: [
                        Expanded(
                          child: getDefaultTextFiledWithLabel(
                              context, ('startTime').tr(), timeCtrl,
                              isEnable: false,
                              height: 60.h,
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
                        // getHorSpace(20.h),
                        // Expanded(
                        //   child: getDefaultTextFiledWithLabel(
                        //       context, "End time", controller.endTimeController,
                        //       isEnable: false,
                        //       height: 60.h,
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

                    getVerSpace(20.h),
                    getCustomFont(("venueAddress").tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                    getVerSpace(4.h),
                    getDefaultTextFiledWithLabel(
                        context, ("enterAddress").tr(), locCtrl,
                        isEnable: false, height: 60.h, minLines: true),
                    getVerSpace(20.h),
                    getCustomFont(
                        ("chooseLocationAddress").tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                    getVerSpace(10.h),
                    Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * .4,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              // target:  currentPosition == null? const LatLng(-6.1753924, 106.8249641): LatLng(currentPosition!.latitude, currentPosition!.longitude),
                              target: const LatLng(40.730610, -73.935242),
                              zoom: 10,
                            ),
                            markers: Set<Marker>.of(markers.values),
                            // onMapCreated: onMapCreated,

                            onCameraMove: (position) {
                              setState(() {
                                _controllerLatitude.text =
                                    position.target.latitude.toString();
                                _controllerLongitude.text =
                                    position.target.longitude.toString();
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
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * .17),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 30,
                              ),
                            )),
                      ],
                    ),

                    getVerSpace(20.h),
                    getCustomFont(("latitude").tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                    getVerSpace(5.h),
                    TextFormField(
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          fontFamily: Constant.fontsFamily),
                      decoration: InputDecoration(
                          hintText: ("latitude").tr(),
                          counter: Container(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          isDense: true,
                          prefixIcon: Icon(Icons.multiple_stop),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.h)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.h)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: accentColor, width: 1.h)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: errorColor, width: 1.h)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: errorColor, width: 1.h)),
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5.h,
                              fontFamily: Constant.fontsFamily),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.h)),
                          suffixIconConstraints: BoxConstraints(
                            maxHeight: 24.h,
                          ),
                          hintStyle: TextStyle(
                              color: greyColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
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
                    getVerSpace(10.h),

                    getCustomFont(("longitude").tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                    getVerSpace(5.h),
                    TextFormField(
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          fontFamily: Constant.fontsFamily),
                      decoration: InputDecoration(
                          hintText: ("longitude").tr(),
                          counter: Container(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          isDense: true,
                          prefixIcon: Icon(Icons.multiple_stop),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.h)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.h)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: accentColor, width: 1.h)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: errorColor, width: 1.h)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: errorColor, width: 1.h)),
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5.h,
                              fontFamily: Constant.fontsFamily),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22.h),
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.h)),
                          suffixIconConstraints: BoxConstraints(
                            maxHeight: 24.h,
                          ),
                          hintStyle: TextStyle(
                              color: greyColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
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

                    getVerSpace(30.h),
                    isButtonDisabled
                        ? loading == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : getButton(
                                context,
                                accentColor,
                                ("pleaseAddData").tr(),
                                Colors.white,
                                () {},
                                18.sp,
                                weight: FontWeight.w700,
                                borderRadius: BorderRadius.circular(22.h),
                                buttonHeight: 60.h)
                        : loading == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : getButton(context, accentColor, ("publish").tr(),
                                Colors.white, () {
                                handleUpdateData();
                              }, 18.sp,
                                weight: FontWeight.w700,
                                borderRadius: BorderRadius.circular(22.h),
                                buttonHeight: 60.h),
                    getVerSpace(50.h),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  // Column buildImageWidget() {
  //   return Column(
  //     children: [
  //       GestureDetector(
  //         onTap: () {
  //           if (controller.image1 == null) {
  //             _onPictureSelection1();
  //           }
  //         },
  //         child: GetBuilder<CreateEventController>(
  //           init: CreateEventController(),
  //           builder: (controller) => controller.image1 == null
  //               ? Container(
  //                   height: 155.h,
  //                   decoration: BoxDecoration(
  //                       color: lightColor,
  //                       borderRadius: BorderRadius.circular(22.h)),
  //                   child: DottedBorder(
  //                       dashPattern: const [6, 6],
  //                       color: accentColor,
  //                       strokeWidth: 1.h,
  //                       radius: Radius.circular(22.h),
  //                       borderType: BorderType.RRect,
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Align(
  //                             alignment: Alignment.topCenter,
  //                             child: Container(
  //                               height: 48.h,
  //                               width: 48.h,
  //                               padding: EdgeInsets.all(14.h),
  //                               decoration: BoxDecoration(
  //                                   color: Colors.white,
  //                                   border: Border.all(
  //                                       color: accentColor, width: 1.h),
  //                                   borderRadius: BorderRadius.circular(13.h)),
  //                               child: getSvgImage("add.svg",
  //                                   color: accentColor,
  //                                   width: 20.h,
  //                                   height: 20.h),
  //                             ),
  //                           ),
  //                           getVerSpace(10.h),
  //                           getCustomFont(
  //                               "Add Cover Image", 15.sp, greyColor, 1,
  //                               fontWeight: FontWeight.w500, txtHeight: 1.46.h),
  //                         ],
  //                       )),
  //                 )
  //               : Container(
  //                   height: 155.h,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(22.h),
  //                       image: DecorationImage(
  //                           image: FileImage(controller.image1!),
  //                           fit: BoxFit.fill)),
  //                 ),
  //         ),
  //       ),
  //       getVerSpace(20.h),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           GestureDetector(
  //             onTap: () {
  //               if (controller.image2 == null) {
  //                 _onPictureSelection2();
  //               }
  //             },
  //             child: GetBuilder<CreateEventController>(
  //               init: CreateEventController(),
  //               builder: (controller) => controller.image2 == null
  //                   ? Container(
  //                       height: 78.h,
  //                       decoration: BoxDecoration(
  //                           color: lightColor,
  //                           borderRadius: BorderRadius.circular(22.h)),
  //                       child: DottedBorder(
  //                         dashPattern: const [6, 6],
  //                         color: accentColor,
  //                         strokeWidth: 1.h,
  //                         padding: EdgeInsets.all(27.h),
  //                         radius: Radius.circular(22.h),
  //                         borderType: BorderType.RRect,
  //                         child: getSvgImage("add.svg",
  //                             color: accentColor, height: 24.h, width: 24.h),
  //                       ),
  //                     )
  //                   : Container(
  //                       width: 78.w,
  //                       height: 78.h,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(22.h),
  //                           image: DecorationImage(
  //                               image: FileImage(controller.image2!),
  //                               fit: BoxFit.fill)),
  //                       padding: EdgeInsets.only(
  //                           top: 8.h, bottom: 52.h, left: 52.h, right: 8.h),
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           controller.onImage2Null();
  //                         },
  //                         child: getSvgImage("close.svg",
  //                             width: 18.h, height: 18.h),
  //                       ),
  //                     ),
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               if (controller.image3 == null) {
  //                 controller.getImage3();
  //               }
  //             },
  //             child: GetBuilder<CreateEventController>(
  //               init: CreateEventController(),
  //               builder: (controller) => controller.image3 == null
  //                   ? Container(
  //                       height: 78.h,
  //                       decoration: BoxDecoration(
  //                           color: lightColor,
  //                           borderRadius: BorderRadius.circular(22.h)),
  //                       child: DottedBorder(
  //                         dashPattern: const [6, 6],
  //                         color: accentColor,
  //                         strokeWidth: 1.h,
  //                         padding: EdgeInsets.all(27.h),
  //                         radius: Radius.circular(22.h),
  //                         borderType: BorderType.RRect,
  //                         child: getSvgImage("add.svg",
  //                             color: accentColor, height: 24.h, width: 24.h),
  //                       ),
  //                     )
  //                   : Container(
  //                       width: 78.w,
  //                       height: 78.h,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(22.h),
  //                           image: DecorationImage(
  //                               image: FileImage(controller.image3!),
  //                               fit: BoxFit.fill)),
  //                       padding: EdgeInsets.only(
  //                           top: 8.h, bottom: 52.h, left: 52.h, right: 8.h),
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           controller.onImage3Null();
  //                         },
  //                         child: getSvgImage("close.svg",
  //                             width: 18.h, height: 18.h),
  //                       ),
  //                     ),
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               if (controller.image4 == null) {
  //                 controller.getImage4();
  //               }
  //             },
  //             child: GetBuilder<CreateEventController>(
  //               init: CreateEventController(),
  //               builder: (controller) => controller.image4 == null
  //                   ? Container(
  //                       height: 78.h,
  //                       decoration: BoxDecoration(
  //                           color: lightColor,
  //                           borderRadius: BorderRadius.circular(22.h)),
  //                       child: DottedBorder(
  //                         dashPattern: const [6, 6],
  //                         color: accentColor,
  //                         strokeWidth: 1.h,
  //                         padding: EdgeInsets.all(27.h),
  //                         radius: Radius.circular(22.h),
  //                         borderType: BorderType.RRect,
  //                         child: getSvgImage("add.svg",
  //                             color: accentColor, height: 24.h, width: 24.h),
  //                       ),
  //                     )
  //                   : Container(
  //                       width: 78.w,
  //                       height: 78.h,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(22.h),
  //                           image: DecorationImage(
  //                               image: FileImage(controller.image4!),
  //                               fit: BoxFit.fill)),
  //                       padding: EdgeInsets.only(
  //                           top: 8.h, bottom: 52.h, left: 52.h, right: 8.h),
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           controller.onImage4Null();
  //                         },
  //                         child: getSvgImage("close.svg",
  //                             width: 18.h, height: 18.h),
  //                       ),
  //                     ),
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               if (controller.image5 == null) {
  //                 controller.getImage5();
  //               }
  //             },
  //             child: GetBuilder<CreateEventController>(
  //               init: CreateEventController(),
  //               builder: (controller) => controller.image5 == null
  //                   ? Container(
  //                       height: 78.h,
  //                       decoration: BoxDecoration(
  //                           color: lightColor,
  //                           borderRadius: BorderRadius.circular(22.h)),
  //                       child: DottedBorder(
  //                         dashPattern: const [6, 6],
  //                         color: accentColor,
  //                         strokeWidth: 1.h,
  //                         padding: EdgeInsets.all(27.h),
  //                         radius: Radius.circular(22.h),
  //                         borderType: BorderType.RRect,
  //                         child: getSvgImage("add.svg",
  //                             color: accentColor, height: 24.h, width: 24.h),
  //                       ),
  //                     )
  //                   : Container(
  //                       width: 78.w,
  //                       height: 78.h,
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(22.h),
  //                           image: DecorationImage(
  //                               image: FileImage(controller.image5!),
  //                               fit: BoxFit.fill)),
  //                       padding: EdgeInsets.only(
  //                           top: 8.h, bottom: 52.h, left: 52.h, right: 8.h),
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           controller.onImage5Null();
  //                         },
  //                         child: getSvgImage("close.svg",
  //                             width: 18.h, height: 18.h),
  //                       ),
  //                     ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  AppBar buildAppBar() {
    return getToolBar(
      () {
        Navigator.of(context).pop();
      },
      title: getCustomFont(("createEvent").tr(), 24.sp, Colors.black, 1,
          fontWeight: FontWeight.w700, textAlign: TextAlign.center),
      leading: true,
    );
  }
}
