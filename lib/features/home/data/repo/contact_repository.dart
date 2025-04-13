import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../../../core/services/base_repository.dart';

class ContactRepository extends BaseRepository {
  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<bool> requestContactsPermission() async {
    return await FlutterContacts.requestPermission();
  }

  Future<List<Map<String, dynamic>>> getRegisteredUsers() async {
    try {
      // Get all users from Firestore
      final usersSnapshot = await firestore.collection('users').get();

      final registeredUsers =
          usersSnapshot.docs
              .map((doc) => UserModel.fromFirestore(doc))
              .toList();

      // Return a list of registered users with only necessary fields
      return registeredUsers
          .where((user) => user.uid != currentUserId) // Exclude current user
          .map((user) {
            return {
              'id': user.uid,
              'name': user.fullName,
              'phoneNumber': user.phoneNumber,
            };
          })
          .toList();
    } catch (e) {
      print('Error getting registered users: $e');
      return [];
    }
  }
}
