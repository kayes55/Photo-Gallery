import 'package:flutter/material.dart';
import 'package:photo_gallery/UI_Components/app_bar.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:photo_gallery/models/imageModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_gallery/utils/shared_pref.dart';

class Bookmarks extends StatefulWidget {
  static const routeName = '/splash';
  final String imageUrl;
  final String uniqueId;
  final String title;

  const Bookmarks({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.uniqueId,
  }) : super(key: key);
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  List<imageModel> _bookmarked = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferenceData.loadData();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ExampleAppBarLayout(
      title: 'Bookmarks',
      showGoBack: true,
      child: GridView.count(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children:
            List.generate(SharedPreferenceData.bookmarked.length, (index) {
          return Center(
            child: CachedNetworkImage(
              imageUrl: SharedPreferenceData.bookmarked[index].url ?? '',
              fit: BoxFit.cover,
              height: 200,
              width: 200,
            ),
          );
        }),
      ),
    );
  }
}
