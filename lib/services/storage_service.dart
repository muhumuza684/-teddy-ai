import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/message.dart';

class StorageService {
  static const _profileKey = 'teddy_user_profile';
  static const _historyPrefix = 'teddy_history_';
  static const _languageKey = 'teddy_language';
  static const _onboardedKey = 'teddy_onboarded';
  static const _dailyTipKey = 'teddy_last_tip_date';

  // ── Profile ──────────────────────────────────────────────
  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<UserProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_profileKey);
    if (str == null) return null;
    return UserProfile.fromJson(jsonDecode(str));
  }

  // ── Chat history per sector ──────────────────────────────
  Future<void> saveHistory(String sectorId, List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final data = messages.map((m) => m.toJson()).toList();
    // Keep only last 50 messages per sector
    final trimmed = data.length > 50 ? data.sublist(data.length - 50) : data;
    await prefs.setString('$_historyPrefix$sectorId', jsonEncode(trimmed));
  }

  Future<List<Message>> loadHistory(String sectorId) async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString('$_historyPrefix$sectorId');
    if (str == null) return [];
    final List<dynamic> data = jsonDecode(str);
    return data.map((m) => Message.fromJson(m)).toList();
  }

  Future<void> clearHistory(String sectorId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_historyPrefix$sectorId');
  }

  // ── Language preference ──────────────────────────────────
  Future<void> saveLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, code);
  }

  Future<String> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'eng';
  }

  // ── Onboarding state ─────────────────────────────────────
  Future<bool> isOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardedKey) ?? false;
  }

  Future<void> setOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardedKey, true);
  }

  // ── Daily tip tracking ───────────────────────────────────
  Future<bool> shouldShowDailyTip() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString(_dailyTipKey);
    if (last == null) return true;
    final lastDate = DateTime.parse(last);
    final now = DateTime.now();
    return now.difference(lastDate).inDays >= 1;
  }

  Future<void> markDailyTipShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dailyTipKey, DateTime.now().toIso8601String());
  }
}
