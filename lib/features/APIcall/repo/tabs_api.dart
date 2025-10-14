import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:openai_app/constants.dart';
import 'package:openai_app/features/APIcall/model/Open_ai_model.dart';

import '../../local_storage.dart';

class TabsAPI {
  static GetTabsAPI(String searchText, String queryText) async {
    var client = http.Client();
    String? content;

    if (queryText == "Meaning") {
      content =
          "Define the word $searchText concisely in ${PreferenceHelper.getString('language')} and also concise sentence using the word $searchText in ${PreferenceHelper.getString('language')}";
    } else if (queryText == "Instagram") {
      content =
          "Create a captivating Instagram caption on :  $searchText concisely in ${PreferenceHelper.getString('language')}";
    } else if (queryText == "Twitter") {
      content =
          "Compose a concise tweet about $searchText in ${PreferenceHelper.getString('language')}";
    }

    try {
      final body = {
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": content}
        ],
        "max_tokens": 100,
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
