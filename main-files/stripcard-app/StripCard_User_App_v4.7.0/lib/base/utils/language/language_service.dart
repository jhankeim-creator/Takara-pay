import 'dart:convert';

import 'package:http/http.dart' as http;

import "package:stripcard/base/api/endpoint/api_endpoint.dart";
import "package:stripcard/base/utils/language/language_model.dart";

class LanguageService {
  Future<List<Language>> fetchLanguages() async {
    final response = await http
        .get(Uri.parse(ApiEndpoint.languagesURL))
        .timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> languageDataList = data["data"]["languages"];
      return languageDataList
          .map((json) => Language.fromJson(json))
          .toList();
    } else {
      // No user-facing snackbar here: the LanguageController catches this and
      // degrades to cached data / the built-in English fallback, so a flaky
      // language API never blocks the app or pops an error at launch.
      throw Exception(
          'Failed to load language data (status ${response.statusCode})');
    }
  }
}
