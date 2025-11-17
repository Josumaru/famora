import 'package:famora/features/auth/presentation/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseUserProvider = Provider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).currentUser;
});

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

final currentMemberProvider = FutureProvider<Map<String, dynamic>?>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  final user = ref.watch(firebaseUserProvider);

  if (user == null) return null;

  final snap = await db.child("members/${user.uid}").get();

  if (!snap.exists) return null;

  return Map<String, dynamic>.from(snap.value as Map);
});
