import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/UI_Components/bookmarks.dart';
import 'package:photo_gallery/models/imageModel.dart';
import 'package:photo_gallery/provider/imageProvider.dart';
import 'package:photo_gallery/utils/utilities.dart';
import 'package:provider/provider.dart';
import 'package:photo_gallery/UI_Components/fullScreenView.dart';
import 'package:photo_gallery/utils/keys.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/homepage';

  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 1;
  bool _isLoading = false;
  bool initial = true; //to check if its first data to be loaded on screen
  bool multigrid = true; //to switch betwwen grid views
  int columnCount = 2; // initial grid column count
  final ScrollController _controller = ScrollController();
  bool _isEndReached = false;

  @override
  void initState() {
    super.initState();
    //calling the api at first to load initial data on screen
    _fetchImages(initial);
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _onEndReached();
      } else {
        _isEndReached = false;
      }
    });
  }

// Define the function to be called when the user reaches the end of the list
  void _onEndReached() {
    if (!_isEndReached) {
      _isEndReached = true;
      initial = false;
      _fetchImages(initial);
    }
  }

  Future<void> _fetchImages(initial) async {
    if (await Permission.storage.request().isGranted) {
      debugPrint('called');
      // Either the permission was already granted before or the user just granted it.
      // important to check internet connection before api calling
      if (await Utils.connectivityCheck()) {
        try {
          //initialising provider
          final imageProvider =
              Provider.of<PhotoProvider>(context, listen: false);
          if (initial) {
            _currentPage = 1;
            //clearing previous data in provider to load new data on initial page load
            imageProvider.imageList.clear();
          }
          if (_isLoading) {
            return;
          }
          setState(() {
            _isLoading = true;
          });
          //calling the api

          final response = await http.get(Uri.parse(
              'https://api.unsplash.com/photos?client_id=${Keys.UNSPLASH_API_CLIENT_ID}&per_page=10&page=$_currentPage'));
          //decoding the json obtained from api
          final jsonData = json.decode(response.body);
          //storing each data from json to a image model which is custom made
          for (var i = 0; i < jsonData.length; i++) {
            imageProvider.addImageData(imageModel(
              id: jsonData[i]['id'],
              author: jsonData[i]['user']['name'],
              url: jsonData[i]['urls']['regular'],
              width: jsonData[i]['width'],
              height: jsonData[i]['height'],
              uniqueId: jsonData[i]['id'] +
                  jsonData[i]['urls']['regular'] +
                  DateTime.now().millisecondsSinceEpoch.toString(),
            ));
          }
          //some photos might have same id, so created a custom unique id with ( id,albumid,url,current timestamp ) on phone
          setState(() {
            //incrementing page counter
            _currentPage++;
            _isLoading = false;
          });
          if (jsonData.length != null && jsonData.length != 0 && !initial) {
            //show toast to user indicating more data is loaded when scrolled down to end of list
            Fluttertoast.showToast(
                msg: "More photos available, scroll down",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        Fluttertoast.showToast(
            msg: "No internet connection",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      //calling again because user should give permission else datagrid wont be loaded
      _fetchImages(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<PhotoProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                  Icons.bookmark_add_rounded,
                  color: Colors.blue,
                ),
                onPressed: () {
                  // Add navigation to bookmarks page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Bookmarks(
                        imageUrl: '',
                        title: '',
                        uniqueId: '',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          toolbarHeight: 70,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Hero(
            tag: 'logo',
            child: Image.asset(
              'assets/images/logo_icon.png',
              fit: BoxFit.fitHeight,
              height: 40,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: (() => _fetchImages(true)),
          child: GridView.count(
            controller: _controller,
            padding: const EdgeInsets.only(top: 10),
            crossAxisCount: columnCount,
            children: imageProvider.imageList.map((image) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: GestureDetector(
                  onTap: () {
                    //routing to detailed view of the thumbnail image
                    // set necessary set up
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HeroExample(
                          imageUrl: image.url.toString(),
                          title: image.author.toString(),
                          uniqueId: image.uniqueId.toString(),
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: image.uniqueId.toString(),
                    child: CachedNetworkImage(
                      height: 200.0,
                      width: 200.0,
                      fit: BoxFit.fill,
                      imageUrl: image.url.toString(),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
