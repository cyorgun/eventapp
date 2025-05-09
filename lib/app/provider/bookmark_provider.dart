import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:event_app/app/provider/sign_in_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider extends ChangeNotifier {
  List<String>? _list;

  List<String>? get list => _list;

  Future<List> getArticles(String? uid) async {
    String _collectionName = 'event';
    String _fieldName = 'bookmarked items';

    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot snap = await ref.get();
    List bookmarkedList = snap[_fieldName];
    print('mainList: $bookmarkedList');

    List d = [];
    // ignore: unnecessary_null_comparison
    if (bookmarkedList != null &&
        bookmarkedList.isNotEmpty &&
        bookmarkedList.length <= 10) {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .where('id', whereIn: bookmarkedList)
          .get()
          .then((QuerySnapshot snap) {
        d.addAll(snap.docs.map((e) => EventBaru.fromFirestore(e,1)).toList());
      });
    } else if (bookmarkedList == null || bookmarkedList.isEmpty) {
      print('bookmarkedList is empty or null');
    } else if (bookmarkedList.length > 10) {
      int size = 10;
      var chunks = [];

      for (var i = 0; i < bookmarkedList.length; i += size) {
        var end = (i + size < bookmarkedList.length)
            ? i + size
            : bookmarkedList.length;
        chunks.add(bookmarkedList.sublist(i, end));
      }

      await FirebaseFirestore.instance
          .collection(_collectionName)
          .where('id', whereIn: chunks[0])
          .get()
          .then((QuerySnapshot snap) {
        d.addAll(snap.docs.map((e) => EventBaru.fromFirestore(e,1)).toList());
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection(_collectionName)
            .where('id', whereIn: chunks[1])
            .get()
            .then((QuerySnapshot snap) {
          d.addAll(
              snap.docs.map((e) => EventBaru.fromFirestore(e,1)).toList());
        });
      });
    } else if (bookmarkedList.length > 20) {
      int size = 10;
      var chunks = [];

      for (var i = 0; i < bookmarkedList.length; i += size) {
        var end = (i + size < bookmarkedList.length)
            ? i + size
            : bookmarkedList.length;
        chunks.add(bookmarkedList.sublist(i, end));
      }

      await FirebaseFirestore.instance
          .collection(_collectionName)
          .where('id', whereIn: chunks[0])
          .get()
          .then((QuerySnapshot snap) {
        d.addAll(snap.docs.map((e) => EventBaru.fromFirestore(e, 1)).toList());
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection(_collectionName)
            .where('id', whereIn: chunks[1])
            .get()
            .then((QuerySnapshot snap) {
          d.addAll(
              snap.docs.map((e) => EventBaru.fromFirestore(e, 1)).toList());
        });
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection(_collectionName)
            .where('id', whereIn: chunks[2])
            .get()
            .then((QuerySnapshot snap) {
          d.addAll(
              snap.docs.map((e) => EventBaru.fromFirestore(e, 1)).toList());
        });
      });
    }
    return d;
  }

  Future<List> getDataList() async {
    String _collectionName = 'contents';
    String _fieldName = 'interest_items';

    SharedPreferences sp = await SharedPreferences.getInstance();
    String? _uid = sp.getString('uid');

    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(_uid);
    DocumentSnapshot snap = await ref.get();
    List interestItem = snap[_fieldName];
    print('mainList: $interestItem');

    return interestItem;
  }

  Future getInterestDataFromFirebase(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot snap) {
      this._list = snap['interest_items'];

      print(_list);
    });
    notifyListeners();
  }

  Future saveInterestToFirebase(value, String? uid) async {
    String _fieldName = 'interest_items';
    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot snap = await ref.get();

    // value = snap[_fieldName];

    await ref.update({_fieldName: FieldValue.arrayUnion(value)});
    this._list = value;
    print("test" + value.toString());
    print("test uid " + uid.toString());
    print("test" + value.toString());
    notifyListeners();
  }

  Future onBookmarkIconClick(String? timestamp, String? uid) async {
    String _fieldName = 'bookmarked items';

    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot snap = await ref.get();
    List d = snap[_fieldName];

    if (d.contains(timestamp)) {
      List a = [timestamp];
      await ref.update({_fieldName: FieldValue.arrayRemove(a)});
    } else {
      d.add(timestamp);
      await ref.update({_fieldName: FieldValue.arrayUnion(d)});
    }
    notifyListeners();
  }
}
