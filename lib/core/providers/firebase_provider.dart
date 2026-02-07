import 'package:famora/features/auth/presentation/providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// final firebaseUserProvider = Provider<User?>((ref) {
//   return ref.watch(firebaseAuthProvider).currentUser;
// });

final firebaseDatabaseProvider = Provider<FirebaseDatabase>((ref) {
  return FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: dotenv.env['FIREBASE_DB_URL'],
  );
});

final databaseProvider = Provider<DatabaseReference>((ref) {
  final db = ref.watch(firebaseDatabaseProvider);
  return db.ref();
});

final currentUserProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final db = ref.watch(databaseProvider);
  final user = ref.watch(firebaseAuthProvider).currentUser;

  if (user == null) return null;

  final snap = await db.child("members/${user.uid}").get();

  if (!snap.exists) return null;

  return Map<String, dynamic>.from(snap.value as Map);
});

final currentMemberProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, groupId) async {
      final db = ref.watch(databaseProvider);
      final user = ref.watch(firebaseAuthProvider).currentUser;

      if (user == null) return null;

      final snap = await db.child("members").get();

      if (!snap.exists) return null;

      final members = Map<String, dynamic>.from(snap.value as Map);

      // cari member dengan uid sama + groupId sama
      for (final entry in members.entries) {
        final member = Map<String, dynamic>.from(entry.value);

        if (member['uid'] == user.uid && member['groupId'] == groupId) {
          return member;
        }
      }

      return null;
    });
