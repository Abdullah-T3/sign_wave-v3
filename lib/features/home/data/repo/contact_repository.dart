import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../../core/services/base_repository.dart';
import '../../../auth/data/models/user_model.dart';

class ContactRepository extends BaseRepository {
  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<bool> requestContactsPermission() async {
    return await FlutterContacts.requestPermission();
  }

  Future<List<Map<String, dynamic>>> getRegisteredContacts() async {
    try {
      print('Getting registered contacts');
      bool hasPermission = await requestContactsPermission();
      if (!hasPermission) {
        print('Contacts permission denied');
        return [];
      }

      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );

      final phoneNumbers =
          contacts
              .where((contact) => contact.phones.isNotEmpty)
              .map(
                (contact) => {
                  'name': contact.displayName,
                  'phoneNumber': contact.phones.first.number.replaceAll(
                    RegExp(r'[^\d+]'),
                    '',
                  ),
                  'photo': contact.photo,
                },
              )
              .toList();
      print('Phone numbers: ${phoneNumbers}');
      final usersSnapshot = await firestore.collection('users').get();

      final registeredUsers =
          usersSnapshot.docs
              .map((doc) => UserModel.fromFirestore(doc))
              .toList();

      final matchedContacts =
          phoneNumbers
              .where((contact) {
                String phoneNumber = formatEgyptianPhoneNumber(
                  contact["phoneNumber"].toString(),
                );
                print('Phone number: $phoneNumber');
                return registeredUsers.any(
                  (user) =>
                      user.phoneNumber == phoneNumber &&
                      user.uid != currentUserId,
                );
              })
              .map((contact) {
                String phoneNumber = formatEgyptianPhoneNumber(
                  contact["phoneNumber"].toString(),
                );

                final registeredUser = registeredUsers.firstWhere(
                  (user) => user.phoneNumber == phoneNumber,
                );
                print(
                  "Registered user: ${registeredUser.uid} - ${registeredUser.phoneNumber}",
                );
                return {
                  'id': registeredUser.uid,
                  'name': contact['name'],
                  'phoneNumber': contact['phoneNumber'],
                };
              })
              .toList();
      print('Matched contacts: ${matchedContacts.length}');
      return matchedContacts;
    } catch (e) {
      print('Error getting registered contacts: $e');
      return [];
    }
  }

  String formatEgyptianPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters except the plus sign
    phoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Handle international format with +20
    if (phoneNumber.startsWith("+20")) {
      return phoneNumber.substring(3, phoneNumber.length);
    }
    if (phoneNumber.startsWith("+20") && phoneNumber.length == 13) {
      return phoneNumber.substring(2, phoneNumber.length);
    }

    // Handle international format with 0020
    if (phoneNumber.startsWith("0020")) {
      return phoneNumber.substring(4);
    }

    // Handle local format starting with 0
    if (phoneNumber.startsWith("0") && (phoneNumber.length == 11)) {
      return phoneNumber;
    }

    // If it's already in the correct format (10 digits without prefix)
    if (phoneNumber.length == 10 &&
        (phoneNumber.startsWith("10") ||
            phoneNumber.startsWith("11") ||
            phoneNumber.startsWith("12") ||
            phoneNumber.startsWith("15"))) {
      return phoneNumber = "0$phoneNumber";
    }

    return phoneNumber;
  }
}
