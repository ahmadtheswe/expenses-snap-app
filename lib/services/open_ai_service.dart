import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/open_ai_return.dart';

class OpenAIService {
  static final openAIKey = dotenv.env['OPENAI_API_KEY'];
  static final openAIModel = dotenv.env['OPENAI_MODEL'];

  Future<OpenAIReturn> sendImageToOpenAI(File imageFile) async {
    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');

    final headers = {'Authorization': 'Bearer $openAIKey', 'Content-Type': 'application/json'};

    final body = await _createRequestBody(imageFile);

    try {
      final res = await http.post(uri, headers: headers, body: body);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final dataChoice = data['choices'][0]['message']['content'];

        try {
          final cleanedReply = _cleanApiResponseString(dataChoice);

          Map<String, dynamic> jsonMap;

          try {
            jsonMap = jsonDecode(cleanedReply);
          } catch (parseError) {
            final jsonStart = cleanedReply.indexOf('{');
            final jsonEnd = cleanedReply.lastIndexOf('}') + 1;

            if (jsonStart >= 0 && jsonEnd > jsonStart) {
              final jsonSubstring = cleanedReply.substring(jsonStart, jsonEnd);
              jsonMap = jsonDecode(jsonSubstring);
            } else {
              return OpenAIReturn(total: null, currency: null, label: "Error: Could not parse JSON response");
            }
          }

          return OpenAIReturn.fromJson(jsonMap);
        } catch (parseError) {
          print('JSON parse error: $parseError');
          print('Raw reply: $dataChoice');

          return OpenAIReturn(total: null, currency: null, label: "Error parsing AI response: $parseError");
        }
      } else {
        throw Exception('Failed to get response: ${res.body}');
      }
    } catch (e) {
      return OpenAIReturn(total: null, currency: null, label: 'Error: ${e.toString()}');
    }
  }

  Future<String> _createRequestBody(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    return jsonEncode({
      "model": openAIModel ?? "gpt-4o",
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text": """
                You are given an image of a bill or receipt. Please extract:
                - The total billing amount
                - The currency (if available)
                - The label next to the total (e.g., "Total Due", "Amount Payable")
                
                Respond in JSON:
                {
                  "total": "...",
                  "currency": "...",
                  "label": "..."
                }
                """,
            },
            {
              "type": "image_url",
              "image_url": {"url": "data:image/jpeg;base64,$base64Image"},
            },
          ],
        },
      ],
      "max_tokens": 300,
    });
  }

  String _cleanApiResponseString(String input) {
    return input
        .trim()
        .replaceAll(RegExp(r'\\+'), '\\')
        .replaceAll('\\"', '"')
        .replaceAll('\\n', ' ')
        .replaceAll(RegExp(r'```json\s*|\s*```'), '');
  }
}
