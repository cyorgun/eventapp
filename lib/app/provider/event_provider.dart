import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  List<EventBaru> _dataPopular = [];

  List<EventBaru> get data => _dataPopular;

  List<EventBaru> _dataTrending = [];

  List<EventBaru> get data2 => _dataTrending;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _snap = [];

  DocumentSnapshot? _lastVisible;

  DocumentSnapshot? get lastVisible => _lastVisible;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  bool? _hasData;

  bool? get hasData => _hasData;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
      _lastVisible = rawData.docs[rawData.docs.length - 1];
      if (mounted) {
        _isLoading = false;
        _snap.addAll(rawData.docs);
        _dataPopular = _snap.map((e) => EventBaru.fromFirestore(e, 1)).toList();
        notifyListeners();
      }
    } else {
      if (_lastVisible == null) {
        _isLoading = false;
        _hasData = true;
        print('no more items');
      } else {
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
          .where('type', isEqualTo: 'category')
          .get();
    else
      rawData = await firestore
          .collection('event')
          .where('type', isEqualTo: 'category')
          .get();

    if (rawData.docs.length > 0) {
      _lastVisible = rawData.docs[rawData.docs.length - 1];
      if (mounted2) {
        _isLoading = false;
        _snap.addAll(rawData.docs);
        _dataTrending =
            _snap.map((e) => EventBaru.fromFirestore(e, 1)).toList();
        notifyListeners();
      }
    } else {
      if (_lastVisible == null) {
        _isLoading = false;
        _hasData = true;
        print('no more items');
      } else {
        _isLoading = false;
        _hasData = true;
        print('no more items');
      }
    }
    notifyListeners();
    return null;
  }

  Future<bool> isUserJoinedEvent(String eventId, String userId) async {
    DocumentSnapshot<Map<String, dynamic>> eventDoc = await FirebaseFirestore.instance
        .collection("event")
        .doc(eventId)
        .get();

    if (eventDoc.exists) {
      List<dynamic> joinedUsers = eventDoc.data()?["joinEvent"] ?? [];
      return joinedUsers.contains(userId);
    }

    return false;
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

// Future<List<EventBaru>> getAllData() async {
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

//    Future<List<EventBaru>> retrieveEmployees() async {
//     QuerySnapshot<Map<String, dynamic>> snapshot =
//         await _db.collection("Event").get();
//     return snapshot.docs
//         .map((docSnapshot) => Event.fromDocumentSnapshot(docSnapshot))
//         .toList();
//   }
}
