import 'dart:convert';

class imageModel {
  final String? id;
  final String? author;
  final String? url;
  final int? width;
  final int? height;
  final String? uniqueId;

  imageModel(
      {this.id, this.author, this.url, this.width, this.height, this.uniqueId});

  Map<String, String> toJson() {
    return {
      'id': id ?? '',
      'author': author ?? '',
      'url': url ?? '',
    };
  }
}
