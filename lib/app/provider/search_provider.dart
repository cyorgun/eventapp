import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchProvider with ChangeNotifier {
  SearchProvider() {
    getRecentSearchList();
  }

  List<String> _recentSearchData = [];

  List<String> get recentSearchData => _recentSearchData;

  String _searchText = '';

  String get searchText => _searchText;

  bool _searchStarted = false;

  bool get searchStarted => _searchStarted;

  TextEditingController _textFieldCtrl = TextEditingController();

  TextEditingController get textfieldCtrl => _textFieldCtrl;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getRecentSearchList() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData = sp.getStringList('recent_search_data') ?? [];
    notifyListeners();
  }

  Future addToSearchList(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData.add(value);
    await sp.setStringList('recent_search_data', _recentSearchData);
    notifyListeners();
  }

  Future removeFromSearchList(String value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _recentSearchData.remove(value);
    await sp.setStringList('recent_search_data', _recentSearchData);
    notifyListeners();
  }

  Future<List> getData() async {
    List<EventBaru> data = [];
    QuerySnapshot rawData = await firestore.collection('event').get();

    List<DocumentSnapshot> _snap = [];
    _snap.addAll(rawData.docs.where((u) => (u['title']
            .toLowerCase()
            .contains(_searchText.toLowerCase()) ||
        u['location'].toLowerCase().contains(_searchText.toLowerCase()) ||
        u['description'].toLowerCase().contains(_searchText.toLowerCase()))));
    data = _snap.map((e) => EventBaru.fromFirestore(e, 1)).toList();
    return data;
  }

  setSearchText(value) {
    _textFieldCtrl.text = value;
    _searchText = value;
    _searchStarted = true;
    notifyListeners();
  }

  searchInitialize() {
    _textFieldCtrl.clear();
    _searchStarted = false;
    notifyListeners();
  }
}
