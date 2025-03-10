import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../modal/modal_event_baru.dart';
import '../../routes/app_routes.dart';
import '../home/search_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List',style: TextStyle( fontFamily: "Sofia",
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black,),),
        centerTitle: true,
        actions: [
          Padding(padding: EdgeInsets.only(right: 20.0,),
          child: InkWell(
            onTap: (){
              Navigator.pushNamed(context, Routes.searchPage);

            },
            child: Icon(Icons.search,color: accentColor,size: 25.0,)),
          )
        ],
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child:   StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("event")
                      
                      .snapshots(),
                  builder: (BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // return loadingCard(context);
                    return CircularProgressIndicator();
                    }

                    if (snapshot.data!.docs.isEmpty) {
return Container();
                      // return Center(child: EmptyScreen());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error'));
                    }
                    return snapshot.hasData
                        ? EventList(
                            list: snapshot.data?.docs,
                            id: snapshot.data?.docs[0].id,
                          )
                        : Container();
                  },
                ),
      ),  
    );
  }
}

class EventList extends StatelessWidget {
  final List<DocumentSnapshot>? list;
  String? id;
  EventList({this.list, this.id});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final user = list?.map((e)
           {
            return EventBaru.fromFirestore(e, 1);
          }).toList();
                  
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, Routes.featuredEventDetailRoute, arguments: user?[i]);
            },
            child: Container(
            height: 120.0,
            margin: const
                EdgeInsets.only(bottom: 10 , left: 20.0, right: 20.0,top: 10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: shadowColor,
                      blurRadius: 27,
                      offset: const Offset(0, 8))
                ],
                borderRadius: BorderRadius.circular(22 )),
            padding: EdgeInsets.only(
                top: 7 , left: 7 , bottom: 6 , right: 20 ),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                color: Colors.black12,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      image: DecorationImage(
                          image: NetworkImage(
                            user?[i].image ?? '',
                          ),
                          fit: BoxFit.cover)),
                ),
                // Image.network(event.image??'',height: 82,width: 82,),
                // getAssetImage(event.image ?? "",
                //     width: 82 , height: 82 ),
                getHorSpace(10 ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5.0,),
                      Container(
                        width: 210 ,
                        child: getCustomFont(user?[i].title ?? "",
                            17.5  , Colors.black, 1,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Sofia",
                            overflow: TextOverflow.ellipsis,
                            txtHeight: 1.5 ),
                      ),
                      Row(
                        children: [
                         const Icon(Icons.location_on,size: 17.0,color: Colors.black26,),
                          getHorSpace(5),
                          Container(
                            width: 200.0,
                            // color: Colors.yellow,
                            child: getCustomFont(
                                user?[i].location ?? "", 15  , greyColor, 1,
                                fontWeight: FontWeight.w500,
                            fontFamily: "Sofia",
                                txtHeight: 1.5 ),
                          ),
                        ],
                      ),
                      getVerSpace(0 ),
                      Row(
                        children: [
                            const Icon(Icons.category,size: 17.0,color: Colors.black26,),
                          getHorSpace(5 ),
                          Container(
                            width: 150 ,
                            child: getCustomFont(user?[i].category ?? "-", 15  ,
                                greyColor, 1,
                                fontWeight: FontWeight.w500,
                            fontFamily: "Sofia",
                                txtHeight: 1.5 ),
                          ),
                        ],
                      ),
                      getVerSpace(7 ),
                    ],
                  ),
                )
              ],
            ),
                ),
          );
        });
  }
}
