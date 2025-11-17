// import 'package:famora/core/providers/firebase_provider.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// final memberProvider = FutureProvider((ref) async {
//   final database = ref.watch(databaseProvider);
//   final user = ref.watch(firebaseAuthProvider);
//   final snapshot = await database
//       .child("members")
//       .orderByChild("groupId")
//       .equalTo(user.currentUser?.uid)
//       .get();
//   if (snapshot.exists) {
//     return snapshot.children.first.value;
//   } else {
//     return null;
//   }
// });
