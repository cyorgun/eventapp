// import 'package:flutter/material.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../base/color_data.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../base/widget_utils.dart';
import '../../provider/sign_in_provider.dart';
import 'Create_Notification_Screen.dart';
import 'Create_User_Screen.dart';
import 'Event_List_Screen.dart';
import 'User_List_Screen.dart';

class Dashboard extends StatefulWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  Dashboard();

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<DauData> dauData = [];

  @override
  void initState() {
    super.initState();
    getDauData();
  }

  Future<void> getDauData() async {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 5));

    // Menggunakan metode logEvent untuk mencatat acara "app_open" setiap kali aplikasi dibuka
    for (DateTime date = startDate; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
      await FirebaseAnalytics.instance.logEvent(name: 'app_open', parameters: {'date': date.toString()});
    }

    // Mengambil data DAU dari Firebase Analytics
    List<DauData> data = await getAnalyticsData(startDate, endDate);

    if (!mounted) return; // Sayfa kapatıldıysa setState çalıştırma

    setState(() {
      dauData = data;
    });
  }

  Future<int> getTotalDocumentLength() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
  int totalLength = querySnapshot.size;
  return totalLength;
}

  Future<List<DauData>> getAnalyticsData(DateTime startDate, DateTime endDate) async {
    // Simulasi pengambilan data DAU dari Firebase Analytics
    // Anda perlu menggantikan ini dengan logika sebenarnya untuk mengambil data dari Firebase Analytics
    await Future.delayed(const Duration(seconds: 2));
 var random = Random();

  // Menghasilkan bilangan bulat acak antara 0 dan 100 (termasuk 0 dan 100)
  int randomNumber = random.nextInt(16);
  
    List<DauData> data = [
      DauData(DateTime.now(), randomNumber),
      DauData(DateTime.now().subtract(const Duration(days: 1)), 26),
      DauData(DateTime.now().subtract(const Duration(days: 2)), 48),
      DauData(DateTime.now().subtract(const Duration(days: 3)), 35),
      DauData(DateTime.now().subtract(const Duration(days: 4)), 53),
      // DauData(DateTime.now().subtract(Duration(days: 5)), 23),
      // DauData(DateTime.now().subtract(Duration(days: 6)), 45),
    ];

    return data;
  }

  // List<charts.Series<DauData, DateTime>> _createData() {
  //   return [
  //     charts.Series<DauData, DateTime>(
  //       id: 'DAU',
  //       displayName: "Weekly",
  //       seriesCategory: "Weekly",
  //       colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
  //       domainFn: (DauData data, _) => data.date,
  //       measureFn: (DauData data, _) => data.users,
  //       data: dauData,
  //     ),
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
 var random = Random();
 int randomNumber = random.nextInt(16);
   List<DauData> data = [
      DauData(DateTime.now(), randomNumber),
      DauData(DateTime.now().subtract(const Duration(days: 1)), 26),
      DauData(DateTime.now().subtract(const Duration(days: 2)), 48),
      DauData(DateTime.now().subtract(const Duration(days: 3)), 35),
      DauData(DateTime.now().subtract(const Duration(days: 4)), 53),
      // DauData(DateTime.now().subtract(Duration(days: 5)), 23),
      // DauData(DateTime.now().subtract(Duration(days: 6)), 45),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(
        fontFamily: "Sofia",
        fontSize: 27,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),),
        backgroundColor: Colors.white,
        elevation: 0,
        actions:  [
          Padding(
            padding: EdgeInsets.only(right:30.0),
            child: Row(
              children: [
                InkWell(
                    onTap: () async {
                      await context
                          .read<SignInProvider>()
                          .userSignOut()
                          .then((value) =>
                          context.read<SignInProvider>().afterUserSignOut())
                          .then((value) {
                        Navigator.popAndPushNamed(context, Routes.loginRoute);
                      });
                    },
                    child: Icon(Icons.person_off_rounded,color: accentColor,)),
                Padding(
                  padding: EdgeInsets.only(left:15.0),
                  child: InkWell(
                     onTap: () {

                      },
                    child: Icon(Icons.notification_add,color: accentColor,)),
                ),
                Padding(
                  padding: EdgeInsets.only(left:15.0),
                  child: InkWell(
                    onTap: () {
                        Navigator.pushNamed(context, Routes.createUserScreen);
                    },
                    child: Icon(Icons.person_add,color: accentColor,)),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left:20.0,top: 20.0,bottom: 10.0),
              child: Text("Active Users",style: TextStyle(
                fontFamily: "Sofia",
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),),
            ),
            dauData.isNotEmpty
                ? Padding(
                  padding: const EdgeInsets.only(left:20.0,right: 20.0),
                  child: Container(
                    height: 280.0,
                    // width: 500.0,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.05),
                          blurRadius: 20.0,
                          spreadRadius: 10.0,
                          offset: const Offset(
                            0.0,
                            10.0,
                          ),
                        )
                      ]
                    ),
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              // title: ChartTitle(text: 'Half yearly sales analysis'),
              // Enable legend
              legend: Legend(isVisible: false),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <CartesianSeries<DauData, String>>[
                LineSeries<DauData, String>(
                    dataSource: data,
                      xValueMapper: (DauData sales, _) => DateFormat.EEEE().format(sales.date), // Change date format to day name
        
                    yValueMapper: (DauData sales, _) => sales.users,
                    
                    // name: 'Sales',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
                      
                      //  charts.TimeSeriesChart(

                      //   defaultInteractions: true,

                      //                 _createData(),
                      //                 animate: true,
                      //                 dateTimeFactory: const charts.UTCDateTimeFactory(
                    
                      // // locale: 'id', // Atur sesuai dengan preferensi Anda
                      //                 ),
                      //                 primaryMeasureAxis: const charts.NumericAxisSpec(
                      // tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false),
                      //                 ),
                      //               ),
              ],
                    )
                  ),
                ))
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                          height: 280.0,
                      // width: 500.0,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 20.0,
                            spreadRadius: 10.0,
                            offset: const Offset(
                              0.0,
                              10.0,
                            ),
                          )
                        ]
                      ),
                  ),
                ),
                const SizedBox(height: 30.0,),
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
      children: [
const Padding(
              padding: EdgeInsets.only(left:0.0,top: 20.0,bottom: 10.0),
              child: Text("Total User",style: TextStyle(
                fontFamily: "Sofia",
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),),
            ),
         Padding(
                  padding: const EdgeInsets.only(left:0.0,right: 0.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, Routes.userListScreen);
                    },
                    child: Container(
                      height: 200.0,
                       width: MediaQuery.of(context).size.width/2.5,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 20.0,
                            spreadRadius: 10.0,
                            offset: const Offset(
                              0.0,
                              10.0,
                            ),
                          )
                        ]
                      ),
                                child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .snapshots(),
                          builder: (BuildContext ctx,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                           
                             if (snapshot.data!.docs.isEmpty) {
                                      return const Center(child: Text("Empty"));
                                    }
                                    if (snapshot.hasError) {
                                      return const Center(child: Text('Error'));
                                    }
                            return snapshot.hasData? 
                            Text(snapshot.data!.docs.length.toString()??'0',
                                style: TextStyle(
                                  fontFamily: "Sofia",
                                  fontSize: 80,
                                  fontWeight: FontWeight.w700,
                                  color: accentColor,
                                ),
                                textAlign: TextAlign.center):
                                const Text("null");
                              }
                              ),
                              const Text("Users",style: TextStyle(  
                                fontFamily: "Sofia",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center),
                        ],
                      ),
                            
                      ),
                  )),
      ],
    ),
     

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
   const Padding(
              padding: EdgeInsets.only(left:0.0,top: 20.0,bottom: 10.0),
              child: Text("Total Event",style: TextStyle(
                fontFamily: "Sofia",
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),),
            ),
         Padding(
                  padding: const EdgeInsets.only(left:0.0,right: 0.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, Routes.eventListScreen);
                    },
                    child: Container(
                      height: 200.0,
                       width: MediaQuery.of(context).size.width/2.5,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 20.0,
                            spreadRadius: 10.0,
                            offset: const Offset(
                              0.0,
                              10.0,
                            ),
                          )
                        ]
                      ),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("event")
                              .snapshots(),
                          builder: (BuildContext ctx,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                           
                             if (snapshot.data!.docs.isEmpty) {
                                      return const Center(child: Text("Empty"));
                                    }
                                    if (snapshot.hasError) {
                                      return const Center(child: Text('Error'));
                                    }
                            return snapshot.hasData? 
                            Text(snapshot.data!.docs.length.toString()??'0',
                                style: TextStyle(
                                  fontFamily: "Sofia",
                                  fontSize: 80,
                                  fontWeight: FontWeight.w700,
                                  color: accentColor,
                                ),
                                textAlign: TextAlign.center):
                                const Text("null");
                              }
                              ),
                              const Text("Events",style: TextStyle(  
                                fontFamily: "Sofia",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center),
                        ],
                      ),
                      ),
                  ),
                    
                    ),
                    
                ],
              ),
                  
  ],
),
            
          ],
        ),
      ),
    );
  }
}

class DauData {
  final DateTime date;
  final int users;

  DauData(this.date, this.users);
}