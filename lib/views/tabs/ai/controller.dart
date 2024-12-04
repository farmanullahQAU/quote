import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:logger/web.dart';
import 'package:myapp/models/quote.dart';

class AiQuoteController extends GetxController {
  late final GenerativeModel model;
  late final ChatSession chat;
  var generatedContent = <dynamic>[].obs;
  var isLoading = false.obs;
  var selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    model = GenerativeModel(
      model: '',
      apiKey: "",
    );
    chat = model.startChat();
  }

  Future<void> sendQuoteRequest(String message, String category) async {
    isLoading.value = true;

    try {
      // Construct the prompt based on whether a category is provided
      String prompt = '''
Please provide quotes as JSON in exactly this format:
[{
  "text": "quote text here",
  "author": "author name",
  "category": "${category.isEmpty ? 'general' : category}",
  "languages": {}
}]
For: $message
Return ONLY the JSON array with maximum 5 quotes. No other text.''';
      generatedContent
          .add(Quote(text: message, isFromUser: true, languages: {}));

      final response = await chat.sendMessage(
        Content.text(prompt),
      );
      var data = response.text;
      var d1 = data?.replaceAll('```json', '');
      var d2 = d1?.replaceAll('```', '');

      if (isJson(d2!)) {
        final List<dynamic> quotesList = jsonDecode(d2);
        for (var quote in quotesList) {
          generatedContent.add(Quote.fromJson(quote, isFromUser: false));
        }
      } else {
        generatedContent.add(data);
      }
    } catch (e) {
      Logger().e(e);
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool isJson(String str) {
    try {
      jsonDecode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  void sendMessage(String text) {
    if (text.trim().isNotEmpty) {
      this.sendQuoteRequest(text, selectedCategory.value);
    }
  }
}
