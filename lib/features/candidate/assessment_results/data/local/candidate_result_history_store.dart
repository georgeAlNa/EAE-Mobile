import 'dart:convert';

import '../../../../../core/constants/shared_pref_keys.dart';
import '../../../../../core/helpers/app_shared_preferences.dart';

class CandidateResultHistoryEntry {
  final String sessionId;
  final String title;
  final String completedAt;

  const CandidateResultHistoryEntry({
    required this.sessionId,
    required this.title,
    required this.completedAt,
  });

  factory CandidateResultHistoryEntry.fromJson(Map<String, dynamic> json) {
    return CandidateResultHistoryEntry(
      sessionId: json['session_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      completedAt: json['completed_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'title': title,
    'completed_at': completedAt,
  };
}

class CandidateResultHistoryStore {
  final AppSharedPreferences sharedPreferences;

  CandidateResultHistoryStore({AppSharedPreferences? sharedPreferences})
    : sharedPreferences = sharedPreferences ?? AppSharedPreferences();

  String? get currentUserId {
    final userId = sharedPreferences
        .getString(AppSharedPrefKeys.userId)
        ?.trim();
    return userId == null || userId.isEmpty ? null : userId;
  }

  List<CandidateResultHistoryEntry> loadForCurrentUser() {
    final userId = currentUserId;
    if (userId == null) return const [];
    return loadForUser(userId);
  }

  List<CandidateResultHistoryEntry> loadForUser(String userId) {
    final normalizedUserId = userId.trim();
    if (normalizedUserId.isEmpty) return const [];

    final history = _readHistory();
    final storedEntries = history[normalizedUserId];
    if (storedEntries is! List) return const [];

    return storedEntries
        .whereType<Map>()
        .map(
          (entry) => CandidateResultHistoryEntry.fromJson(
            Map<String, dynamic>.from(entry),
          ),
        )
        .where((entry) => entry.sessionId.trim().isNotEmpty)
        .toList(growable: false);
  }

  Future<void> recordCompletedSession({
    required String sessionId,
    required String title,
    DateTime? completedAt,
  }) async {
    final userId = currentUserId;
    final normalizedSessionId = sessionId.trim();
    if (userId == null || normalizedSessionId.isEmpty) return;

    final history = _readHistory();
    final entries = loadForUser(userId).toList();
    final existingIndex = entries.indexWhere(
      (entry) => entry.sessionId == normalizedSessionId,
    );

    if (existingIndex >= 0) {
      final existing = entries[existingIndex];
      final normalizedTitle = title.trim();
      if (existing.title.isEmpty && normalizedTitle.isNotEmpty) {
        entries[existingIndex] = CandidateResultHistoryEntry(
          sessionId: existing.sessionId,
          title: normalizedTitle,
          completedAt: existing.completedAt,
        );
      }
    } else {
      entries.insert(
        0,
        CandidateResultHistoryEntry(
          sessionId: normalizedSessionId,
          title: title.trim(),
          completedAt: (completedAt ?? DateTime.now())
              .toUtc()
              .toIso8601String(),
        ),
      );
    }

    history[userId] = entries.map((entry) => entry.toJson()).toList();
    await sharedPreferences.setString(
      AppSharedPrefKeys.candidateResultHistory,
      jsonEncode(history),
    );
  }

  Map<String, dynamic> _readHistory() {
    final encoded = sharedPreferences.getString(
      AppSharedPrefKeys.candidateResultHistory,
    );
    if (encoded == null || encoded.trim().isEmpty) return {};

    try {
      final decoded = jsonDecode(encoded);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : {};
    } catch (_) {
      return {};
    }
  }
}
