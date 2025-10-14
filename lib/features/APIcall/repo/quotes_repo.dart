import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:openai_app/constants.dart';
import 'package:openai_app/features/APIcall/model/Open_ai_model.dart';

import '../../local_storage.dart';

class QuotesRepo {
  static GetQuotesAPI() async {
    var client = http.Client();

    String query;

    final topicsList = PreferenceHelper.getStringList('topics');

    if (topicsList.isNotEmpty) {
      final random = Random();
      final topic = topicsList[random.nextInt(topicsList.length)];
      PreferenceHelper.setString(key: 'topic', value: topic);
      query =
          "generate a one line unique $topic quote in ${PreferenceHelper.getString('language')}";
    } else {
      query =
          "generate a one line unique quote in ${PreferenceHelper.getString('language')}";
    }

    try {
      final body = {
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "user",
            "content": query,
          },
        ],
        // "max_tokens": 100,
        "temperature": 1,
      };
      final jsonString = json.encode(body);
      final uri = Uri.https(ApiConstants.baseUrl, ApiConstants.params);
      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: "Bearer ${dotenv.env['TOKEN'] ?? ''}"
      };
      final response =
          await client.post(uri, headers: headers, body: jsonString);

      // Check if the response is successful
      if (response.statusCode == 200) {
        OpenAiRes resp = openAiResFromJson(response.body.toString());
        return resp;
      } else {
        // Handle API errors (like missing key, rate limits, etc.)
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print(e.toString());
      rethrow; // Re-throw the exception so the bloc can handle it
    } finally {
      client.close();
    }
  }
}
