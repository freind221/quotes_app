import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quota_app/utilis/message.dart';

class RemoteService {
  Future<List<dynamic>?> fetchAuthors(String slug) async {
    http.Response response = await http
        .get(Uri.parse('https://api.quotable.io/search/authors?query=$slug'));
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(jsonDecode(response.body));
        if (data['count'] == 0) {
          return null;
        } else {
          return data['results'];
        }
      }
    } catch (e) {
      Message.toatsMessage(e.toString());
    }
    throw Exception('Error');
  }

  Future<Map<String, dynamic>> searchQuoats(String topic, int limit) async {
    http.Response response = await http.get(Uri.parse(
        'https://api.quotable.io/search/quotes?query=$topic&limit=$limit'));
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(jsonDecode(response.body));

        return data;
      }
    } catch (e) {
      Message.toatsMessage(e.toString());
    }
    throw Exception('Error');
  }

  Future<List<dynamic>?> fetchSearches(String slug, int limit) async {
    http.Response response = await http.get(Uri.parse(
        'https://api.quotable.io/search/quotes?query=$slug&limit=$limit'));
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(jsonDecode(response.body));
        if (data['count'] == 0) {
          return null;
        } else {
          return data['results'];
        }
      }
    } catch (e) {
      Message.toatsMessage(e.toString());
    }
    throw Exception('Error');
  }
}
