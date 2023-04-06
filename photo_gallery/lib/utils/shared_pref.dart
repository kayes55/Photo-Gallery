import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:photo_gallery/models/imageModel.dart';
import 'dart:convert';

class SharedPreferenceData {
  static final SharedPreferenceData _singleton =
      SharedPreferenceData._internal();

  factory SharedPreferenceData() {
    return _singleton;
  }

  SharedPreferenceData._internal();

  static List<imageModel> bookmarked = [];

  static void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> peopleJson = prefs.getStringList('bookmark') ?? [];

    bookmarked.clear();

    for (var personJson in peopleJson) {
      Map<String, dynamic> jsonMap = json.decode(personJson);
      imageModel person =
          imageModel(url: jsonMap['url'], author: jsonMap['author']);
      bookmarked.add(person);
    }
  }

  static void saveData(imageModel data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> imageJson = [];
    bookmarked.add(data);
    for (var image in bookmarked) {
      String varImage = json.encode(image.toJson());
      imageJson.add(varImage);
    }

    prefs.setStringList('bookmark', imageJson);
    loadData();
  }
}
