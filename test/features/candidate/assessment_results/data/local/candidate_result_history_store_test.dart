import 'package:eae_mobile/core/constants/shared_pref_keys.dart';
import 'package:eae_mobile/core/helpers/app_shared_preferences.dart';
import 'package:eae_mobile/features/candidate/assessment_results/data/local/candidate_result_history_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppSharedPreferences preferences;
  late CandidateResultHistoryStore store;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    preferences = AppSharedPreferences();
    await preferences.init();
    await preferences.clear();
    store = CandidateResultHistoryStore(sharedPreferences: preferences);
  });

  Future<void> loginAs(String userId) =>
      preferences.setString(AppSharedPrefKeys.userId, userId);

  test('records a completed assessment session once', () async {
    await loginAs('candidate_a');

    await store.recordCompletedSession(
      sessionId: 'session_001',
      title: 'Flutter Fundamentals',
      completedAt: DateTime.utc(2026, 8, 22),
    );
    await store.recordCompletedSession(
      sessionId: 'session_001',
      title: 'Flutter Fundamentals',
    );

    final history = store.loadForCurrentUser();
    expect(history, hasLength(1));
    expect(history.single.sessionId, 'session_001');
    expect(history.single.title, 'Flutter Fundamentals');
  });

  test('history survives logout while current auth user id does not', () async {
    await loginAs('candidate_a');
    await preferences.setString(AppSharedPrefKeys.token, 'secret-token');
    await preferences.setString(AppSharedPrefKeys.sessionId, 'auth-session');
    await preferences.setString(AppSharedPrefKeys.selectedRole, 'candidate');
    await preferences.setString(AppSharedPrefKeys.language, 'ar');
    await preferences.setBool(AppSharedPrefKeys.theme, true);
    await store.recordCompletedSession(
      sessionId: 'session_001',
      title: 'Flutter Fundamentals',
    );

    await preferences.clearSessionData();

    expect(preferences.getString(AppSharedPrefKeys.userId), isNull);
    expect(preferences.getString(AppSharedPrefKeys.token), isNull);
    expect(preferences.getString(AppSharedPrefKeys.sessionId), isNull);
    expect(preferences.getString(AppSharedPrefKeys.selectedRole), isNull);
    expect(preferences.getString(AppSharedPrefKeys.language), 'ar');
    expect(preferences.getBool(AppSharedPrefKeys.theme), isTrue);

    await loginAs('candidate_a');
    expect(store.loadForCurrentUser().single.sessionId, 'session_001');
  });

  test('histories are isolated by candidate user id', () async {
    await loginAs('candidate_a');
    await store.recordCompletedSession(
      sessionId: 'session_a',
      title: 'Candidate A Exam',
    );

    await loginAs('candidate_b');
    await store.recordCompletedSession(
      sessionId: 'session_b',
      title: 'Candidate B Exam',
    );

    expect(store.loadForCurrentUser().map((entry) => entry.sessionId), [
      'session_b',
    ]);

    await loginAs('candidate_a');
    expect(store.loadForCurrentUser().map((entry) => entry.sessionId), [
      'session_a',
    ]);
  });

  test(
    'does not record without an authenticated user or valid session',
    () async {
      await store.recordCompletedSession(
        sessionId: 'session_001',
        title: 'Exam',
      );
      await loginAs('candidate_a');
      await store.recordCompletedSession(sessionId: '  ', title: 'Exam');

      expect(store.loadForCurrentUser(), isEmpty);
    },
  );
}
