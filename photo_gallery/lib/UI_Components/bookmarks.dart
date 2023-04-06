import 'package:flutter/material.dart';
import 'package:photo_gallery/UI_Components/app_bar.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  Widget build(BuildContext context) {
    return ExampleAppBarLayout(
      title: 'Bookmarks',
      showGoBack: true,
      child: GridView.count(
        crossAxisCount: 2,
        children: List.generate(10, (index) {
          return Center(
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        }),
      ),
    );
  }
}
