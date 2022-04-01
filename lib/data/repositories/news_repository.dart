import 'dart:convert';

import 'package:http/http.dart' as http;

import '../entities/news_entity.dart';

class HttpError extends Error {}

class NewsRepository {
  static String _buildQuery(Map<String, String?> query, {bool attachQuestionMark = false}) {
    final q = query.entries
        .map((entry) => entry.value != null ? '${entry.key}=${entry.value}' : null)
        .whereType<String>()
        .join('&');
    if (q.isEmpty) return '';
    return '${attachQuestionMark ? '?' : ''}$q';
  }

  Future<List<NewsEntity>> getList({String? from, String? searchQuery}) async {
    final query = _buildQuery({'from': from, 'q': searchQuery}, attachQuestionMark: true);
    final resp = await http.get(Uri.parse('https://sarinform.ru/api/list.php$query'));
    if (resp.statusCode != 200) throw HttpError();
    final json = (jsonDecode(resp.body) as List);
    return json.map((e) => NewsEntity.fromJson(e)).toList();
  }

  Future<NewsEntity> getDetails(int id) async {
    final resp = await http.get(Uri.parse('https://sarinform.ru/api/news.php?id=$id'));
    if (resp.statusCode != 200) throw HttpError();
    final json = (jsonDecode(resp.body) as Map<String, dynamic>)['data'] as Map<String, dynamic>;
    return NewsEntity.fromJson(json);
  }
}
