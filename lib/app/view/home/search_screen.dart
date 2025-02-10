import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dialog/loading_cards.dart';
import '../../dialog/snacbar.dart';
import '../../provider/search_provider.dart';
import '../../widget/card4.dart';
import '../../widget/empty_screen.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0))
        .then((value) => context.read<SearchProvider>().saerchInitialize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: _searchBar(),
      ),
      key: scaffoldKey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // suggestion text

            Padding(
              padding: const EdgeInsets.only(
                  top: 15, left: 15, bottom: 5, right: 15),
              child: Text(
                context.watch<SearchProvider>().searchStarted == false
                    ? ('Recent searchs').tr()
                    : ('We have found').tr(),
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            context.watch<SearchProvider>().searchStarted == false
                ? SuggestionsUI()
                : AfterSearchUI()
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white),
      child: TextFormField(
        autofocus: true,
        controller: context.watch<SearchProvider>().textfieldCtrl,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: ("Search item").tr(),
          hintStyle: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close,
              size: 25,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              context.read<SearchProvider>().saerchInitialize();
            },
          ),
        ),
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (value) {
          if (value == '') {
            openSnacbar(scaffoldKey, ('Type something!').tr());
          } else {
            context.read<SearchProvider>().setSearchText(value);
            context.read<SearchProvider>().addToSearchList(value);
          }
        },
      ),
    );
  }
}

class SuggestionsUI extends StatelessWidget {
  const SuggestionsUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SearchProvider>();
    return Expanded(
      child: sb.recentSearchData.isEmpty
          ? EmptyScreen()
          : ListView.separated(
              padding: EdgeInsets.all(15),
              itemCount: sb.recentSearchData.length,
              separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ListTile(
                    title: Text(
                      sb.recentSearchData[index],
                      style: TextStyle(fontSize: 17),
                    ),
                    leading: Icon(
                      CupertinoIcons.time_solid,
                      color: Colors.grey[400],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        context
                            .read<SearchProvider>()
                            .removeFromSearchList(sb.recentSearchData[index]);
                      },
                    ),
                    onTap: () {
                      context
                          .read<SearchProvider>()
                          .setSearchText(sb.recentSearchData[index]);
                    },
                  ),
                );
              },
            ),
    );
  }
}

class AfterSearchUI extends StatelessWidget {
  const AfterSearchUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: context.watch<SearchProvider>().getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0)
              return EmptyScreen();
            else
              return ListView.separated(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: 15,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection('event')
                          .doc(snapshot.data?.id)
                          .update({'count': FieldValue.increment(1)});
                    },
                    child: Card4(
                        events: snapshot.data[index], heroTag: 'search$index'),
                  );
                },
              );
          }
          return ListView.separated(
            padding: EdgeInsets.all(15),
            itemCount: 10,
            separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: 15,
            ),
            itemBuilder: (BuildContext context, int index) {
              return LoadingCard(height: 120);
            },
          );
        },
      ),
    );
  }
}
