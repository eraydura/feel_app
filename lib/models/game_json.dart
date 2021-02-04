import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<GameCategory>> fetchcategory(http.Client client) async {
  final response = await client.get('https://jsonkeeper.com/b/TQWT');
  return compute(parseCategory, response.body);

}

List<GameCategory> parseCategory(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<GameCategory>((json) => GameCategory.fromJson(json)).toList();
}
class GameCategory {
  final String question;
  final String A;
  final String B;
  final String C;
  final String D;
  final String answer;

  GameCategory({ this.question, this.answer,this.A,this.B,this.C,this.D});

  factory GameCategory.fromJson(Map<String, dynamic> json) {
    return GameCategory(
      question: json['question'],
      answer: json['answer'],
      A: json['A'],
      B: json['B'],
      C: json['C'],
      D: json['D'],
    );
  }
}