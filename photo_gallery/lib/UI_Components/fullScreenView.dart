import 'dart:ffi';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:photo_gallery/models/imageModel.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_gallery/UI_Components/app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo_gallery/utils/shared_pref.dart';

class HeroExample extends StatefulWidget {
  static const routeName = '/splash';
  final String imageUrl;
  final String uniqueId;
  final String title;
  final String id;
  final int width;
  final int height;

  const HeroExample({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.uniqueId,
    required this.id,
    required this.width,
    required this.height,
  }) : super(key: key);
  @override
  _HeroExampleState createState() => _HeroExampleState();
}

class _HeroExampleState extends State<HeroExample> {
  double imageHeight = 350;
  double imageWidth = 350;

  bool _favBtn = false;

  @override
  Widget build(BuildContext context) {
    return ExampleAppBarLayout(
      title: "Photo View",
      showGoBack: true,
      child: Center(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Text(
                        'Bookmark this image',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          // do something
                          _toggle();
                          SharedPreferenceData.saveData(
                            imageModel(
                                id: widget.id,
                                author: widget.title,
                                url: widget.imageUrl,
                                width: widget.width,
                                height: widget.height),
                          );
                          // _bookmarked.add(
                          //   imageModel(
                          //       id: widget.id,
                          //       author: widget.title,
                          //       url: widget.imageUrl,
                          //       width: widget.width,
                          //       height: widget.height),
                          // );
                        },
                        child: Icon(
                          Icons.favorite,
                          color: _favBtn ? Colors.red : Colors.grey,
                          size: 24.0,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HeroPhotoViewRouteWrapper(
                          imageProvider: NetworkImage(
                            widget.imageUrl.toString(),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: widget.uniqueId.toString(),
                    child: CachedNetworkImage(
                      height: imageHeight,
                      width: imageWidth,
                      fit: BoxFit.fitWidth,
                      imageUrl: widget.imageUrl,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _favBtn = !_favBtn;
    });
  }
}

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: imageProvider,
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
      ),
    );
  }
}
