import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:evente/evente.dart';

class EventBloc extends ChangeNotifier{
  
  List<Event> _dataPopular = [];
  List<Event> get data => _dataPopular;
  
  List<Event> _dataTrending = [];
  List<Event> get data2 => _dataTrending;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _snap = [];

  DocumentSnapshot? _lastVisible;
  DocumentSnapshot? get lastVisible => _lastVisible;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool? _hasData;
  bool? get hasData => _hasData;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

// Future<List<Event>> getAllData() async {
//     print("Active Users");
//     var val = await firestore
//         .collection("event")
//         .get();
//     var documents = val.docs;
//     print("Documents ${documents.length}");
//     if (documents.length > 0) {
//       try {
//         print("Active ${documents.length}");
//         return documents.map((document) {
//           EventList Event = Event.fromJson(Map<String, dynamic>.from(document.data));
         
//           return Event;
//         }).toList();
//       } catch (e) {
//         print("Exception $e");
//         return [];
//       }
//     }
//     return [];
//   }

//    Future<List<Event>> retrieveEmployees() async {
//     QuerySnapshot<Map<String, dynamic>> snapshot =
//         await _db.collection("Event").get();
//     return snapshot.docs
//         .map((docSnapshot) => Event.fromDocumentSnapshot(docSnapshot))
//         .toList();
//   }


  Future<Null> getDataPopular(mounted) async {
    QuerySnapshot rawData;
     if (_lastVisible == null)
      rawData = await firestore
          .collection('event')
          .where('type', isEqualTo: 'popular')
          .get();
    else
 rawData = await firestore
          .collection('event')
          .where('type', isEqualTo: 'popular')
          .get();

    if (rawData.docs.length > 0) {
     _lastVisible =   rawData.docs[rawData.docs.length - 1];
      if (mounted) {
        _isLoading = false;
        _snap.addAll(rawData.docs);
        _dataPopular = _snap.map((e) => Event.fromFirestore(e)).toList();
        notifyListeners();
      }
    } else {

  if(_lastVisible == null){
        _isLoading = false;
        _hasData = true;
        print('no more items');
       }else{
        _isLoading = false;
        _hasData = true;
        print('no more items');
      }
      
    }
    notifyListeners();
    return null;
  }


  
  Future<Null> getDataTrending(mounted2) async {
    QuerySnapshot rawData;
     if (_lastVisible == null)
      rawData = await firestore
          .collection('event')
          .where('type', isEqualTo: 'trending')
          .get();
    else
 rawData = await firestore
          .collection('event')
          .where('type', isEqualTo: 'trending')
          .get();

    if (rawData.docs.length > 0) {
     _lastVisible =   rawData.docs[rawData.docs.length - 1];
      if (mounted2) {
        _isLoading = false;
        _snap.addAll(rawData.docs);
        _dataTrending = _snap.map((e) => Event.fromFirestore(e)).toList();
        notifyListeners();
      }
    } else {

  if(_lastVisible == null){
        _isLoading = false;
        _hasData = true;
        print('no more items');
       }else{
        _isLoading = false;
        _hasData = true;
        print('no more items');
      }
      
    }
    notifyListeners();
    return null;
  }





  setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }




  onRefresh(mounted, String category) {
    _isLoading = true;
    _snap.clear();
    _dataPopular.clear();
    _dataTrending.clear();
    _lastVisible = null;
    getDataPopular(mounted);
    notifyListeners();
  }



}

