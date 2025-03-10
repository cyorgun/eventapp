import 'package:evente/modal/modal_event.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';


class BarcodeDetailScreen extends StatefulWidget {
  String? data;
  Event? event;
   BarcodeDetailScreen({super.key,this.data,this.event});

  @override
  State<BarcodeDetailScreen> createState() => _BarcodeDetailScreenState();
}

class _BarcodeDetailScreenState extends State<BarcodeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text("Attendes Event",style: TextStyle(fontFamily: "Sofia",fontSize: 18.0,fontWeight: FontWeight.w800),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Title",style: TextStyle(fontFamily: "Sofia",fontWeight: FontWeight.w700,fontSize: 18.0),),
                 Text(widget.data.toString(),style: TextStyle(fontFamily: "Sofia",fontWeight: FontWeight.w300,fontSize: 22.0),),
                 SizedBox(height: 20.0,),
              Text("Location",style: TextStyle(fontFamily: "Sofia",fontWeight: FontWeight.w700,fontSize: 18.0),),
                 Text(widget.event?.location??'',style: TextStyle(fontFamily: "Sofia",fontWeight: FontWeight.w300,fontSize: 22.0),),
                 SizedBox(height: 20.0,),
              Text("Time Event",style: TextStyle(fontFamily: "Sofia",fontWeight: FontWeight.w700,fontSize: 18.0),),
                 Text(widget.event?.time??'',style: TextStyle(fontFamily: "Sofia",fontWeight: FontWeight.w300,fontSize: 22.0),),
                  SizedBox(height: 20.0,),
              Text("Attendees in the Event:",style: TextStyle(fontFamily: "Sofia",fontWeight: FontWeight.w700,fontSize: 18.0),),
                 Row(
                   children: [
                  if (widget.event?.joined != null && widget.event?.join != null && widget.event!.joined! >= widget.event!.join!)    Text(widget.event?.join.toString()??'',style: TextStyle(fontFamily: "Sofia",fontWeight: FontWeight.w700,fontSize: 27.0),),
        
                   if (widget.event?.joined != null && widget.event?.join != null && widget.event!.join! >= widget.event!.joined!)      Text(widget.event?.joined.toString()??'',style: TextStyle(fontFamily: "Sofia",fontWeight: FontWeight.w700,fontSize: 25.0,color: accentColor),),
                     Text(' / '),
                     Text(widget.event?.join.toString()??'',style: TextStyle(fontFamily: "Sofia",fontWeight: FontWeight.w700,fontSize: 27.0),),
        
                   ],
                 ),
            
            ],
          
          ),
        ),
      ),
    );
  }
}