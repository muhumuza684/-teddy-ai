import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_profile.dart';

class SunbirdService {
  static const String _baseUrl = 'https://api.sunbird.ai';
  static String get _apiKey => dotenv.env['SUNBIRD_API_KEY'] ?? '';

  static const Map<String, String> languages = {
    'English': 'eng',
    'Luganda': 'lug',
    'Runyankole': 'nyn',
    'Acholi': 'ach',
    'Ateso': 'teo',
    'Lugbara': 'lgg',
  };

  String? _knowledgeCache;

  Future<String> _loadKnowledge() async {
    _knowledgeCache ??= await rootBundle.loadString('assets/knowledge/uganda_knowledge.txt');
    return _knowledgeCache!;
  }

  String _buildSystemPrompt(UserProfile? profile, String knowledge) {
    final personalContext = profile != null
        ? '''
CURRENT USER PROFILE:
- Name: ${profile.name}
- District: ${profile.district}
- Occupation: ${profile.occupation}
- Tribe/Community: ${profile.tribe}
- Interests: ${profile.interests.join(', ')}

Always greet them by name when starting a fresh conversation.
Tailor your answers to their district and occupation when relevant.
If they are a farmer in ${profile.district}, give advice specific to that region.
'''
        : '';

    return '''
You are Teddy AI 🐻 — Uganda's most trusted AI assistant, built in Uganda for Ugandans.

$personalContext

YOUR IDENTITY:
- You are Teddy AI. Never mention any other AI system.
- You are warm, wise, and deeply Ugandan in character.
- You speak English, Luganda, Runyankole, Acholi, Ateso, and Lugbara.
- You understand Ugandan culture, traditions, humour, and context deeply.
- Think of yourself as that smart, educated relative everyone wants — helpful, never judging.

RESPONSE RULES:
- Always respond in the SAME language the user writes in.
- Be practical and specific — give real names, real numbers, real places.
- Keep responses clear and mobile-friendly (not too long).
- Use Ugandan references: Owino market, Mulago hospital, Makerere, LC1, etc.
- When someone is in trouble (health, legal), lead with immediate action steps.
- Use occasional warm expressions: "Oli otya!", "Webale!", "Kale!", "Naye!" where natural.

UGANDA KNOWLEDGE BASE (use this as your primary reference):
$knowledge
''';
  }

  Future<String> chat({
    required String userMessage,
    required String languageCode,
    UserProfile? profile,
    List<Map<String, String>> history = const [],
  }) async {
    try {
      final knowledge = await _loadKnowledge();
      final systemPrompt = _buildSystemPrompt(profile, knowledge);

      final messages = [
        ...history.take(20),
        {'role': 'user', 'content': userMessage},
      ];

      final response = await http.post(
        Uri.parse('$_baseUrl/tasks/chat'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'messages': messages,
          'system': systemPrompt,
          'language': languageCode,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ??
            data['content'] ??
            data['message'] ??
            'Mpumulo — Teddy could not respond. Please try again.';
      } else if (response.statusCode == 401) {
        return '🔑 API key issue. Please check your Sunbird API key.';
      } else {
        return 'Something went wrong (${response.statusCode}). Please try again.';
      }
    } on SocketException {
      return '📵 No internet connection. Please check your network and try again.';
    } catch (e) {
      return 'Teddy had a problem: $e\n\nPlease try again.';
    }
  }

  Future<String> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/tasks/nllb_translate'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'text': text,
          'source_language': sourceLanguage,
          'target_language': targetLanguage,
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['translated_text'] ?? text;
      }
      return text;
    } catch (_) {
      return text;
    }
  }

  Future<String?> speechToText({
    required String audioFilePath,
    required String languageCode,
  }) async {
    try {
      final file = File(audioFilePath);
      final bytes = await file.readAsBytes();
      final base64Audio = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('$_baseUrl/tasks/asr'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'audio': base64Audio,
          'language': languageCode,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['text'] ?? data['transcript'];
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> textToSpeech({
    required String text,
    required String languageCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/tasks/tts'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'text': text,
          'language': languageCode,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['audio'] ?? data['audio_base64'];
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
