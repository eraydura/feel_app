import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<MusicCategory>> fetchMusicCategory(http.Client client) async {
  final response = await client.get('https://jsonkeeper.com/b/252V');
  return compute(parseMusicCategory, response.body);

}

List<MusicCategory> parseMusicCategory(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<MusicCategory>((json) => MusicCategory.fromJson(json)).toList();
}

class MusicCategory {
  final String title;
  final String image;
  final String emotion;
  final String artist;
  final String category;
  final String album;
  final String assetUrl;

  MusicCategory({ this.title, this.image, this.emotion,this.album,this.artist,this.assetUrl,this.category});

  factory MusicCategory.fromJson(Map<String, dynamic> json) {
    return MusicCategory(
      title: json['title'],
      assetUrl: json['assetUrl'],
      category: json['category'],
      image: json['image'],
      emotion: json['emotion'],
      album: json['album'],
      artist: json['artist'],
    );
  }
}