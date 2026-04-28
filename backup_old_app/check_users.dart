import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lib/backend/firebase/firebase_config.dart';

/// Firebase User Checker
/// Checks for specific phone numbers and lists all users with their emails
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🔍 Checking Firebase Users...\n');
  print('=' * 60);

  try {
    // Initialize Firebase
    await initFirebase();
    print('✅ Firebase initialized\n');

    final firestore = FirebaseFirestore.instance;

    // Phone numbers to search for
    final phoneNumbers = [
      '9828096110',
      '919828096110',
      '+919828096110',
    ];

    print('📱 Searching for specific phone numbers:');
    print('-' * 60);

    for (var phone in phoneNumbers) {
      try {
        final query = await firestore
            .collection('users')
            .where('phone_number', isEqualTo: phone)
            .get()
            .timeout(Duration(seconds: 10));

        if (query.docs.isEmpty) {
          print('❌ $phone - Not found');
        } else {
          print('✅ $phone - Found!');
          for (var doc in query.docs) {
            final data = doc.data();
            print('   📧 Email: ${data['email'] ?? 'No email'}');
            print('   👤 Name: ${data['display_name'] ?? 'No name'}');
            print('   🆔 UID: ${doc.id}');
            print('   📞 Stored as: ${data['phone_number']}');
          }
        }
        print('');
      } catch (e) {
        print('⚠️  Error searching $phone: $e\n');
      }
    }

    // Get ALL users from database
    print('\n' + '=' * 60);
    print('👥 ALL USERS IN DATABASE:');
    print('=' * 60);

    try {
      final allUsers = await firestore
          .collection('users')
          .limit(50)
          .get()
          .timeout(Duration(seconds: 10));

      if (allUsers.docs.isEmpty) {
        print('⚠️  No users found in database');
        print('   The users collection is empty.');
      } else {
        print('Found ${allUsers.docs.length} user(s):\n');

        int index = 1;
        for (var doc in allUsers.docs) {
          final data = doc.data();
          print('User #$index:');
          print('  📧 Email: ${data['email'] ?? 'N/A'}');
          print('  👤 Display Name: ${data['display_name'] ?? 'N/A'}');
          print('  📞 Phone: ${data['phone_number'] ?? 'N/A'}');
          print('  🆔 UID: ${data['uid'] ?? doc.id}');
          print('  🏷️  Role ID: ${data['role_id'] ?? 'N/A'}');
          print('  📍 Location: ${data['location'] ?? 'N/A'}');
          print('  🏙️  City: ${data['city'] ?? 'N/A'}');
          print('  📅 Created: ${data['created_time']?.toString() ?? 'N/A'}');
          print('  📄 Document ID: ${doc.id}');
          print('-' * 60);
          index++;
        }
      }
    } catch (e) {
      print('❌ Error fetching all users: $e');
    }

    // Try alternative phone number formats
    print('\n' + '=' * 60);
    print('🔎 ALTERNATIVE SEARCH - Phone field variations:');
    print('=' * 60);

    try {
      // Search without filtering - get all and check
      final allDocs = await firestore
          .collection('users')
          .get()
          .timeout(Duration(seconds: 10));

      print(
          'Checking ${allDocs.docs.length} documents for phone number matches...\n');

      bool foundMatch = false;
      for (var doc in allDocs.docs) {
        final data = doc.data();
        final phone = data['phone_number']?.toString() ?? '';

        // Check if phone contains our target number
        if (phone.contains('9828096110')) {
          foundMatch = true;
          print('✅ MATCH FOUND:');
          print('   Document ID: ${doc.id}');
          print('   Phone stored as: "$phone"');
          print('   Email: ${data['email'] ?? 'N/A'}');
          print('   Name: ${data['display_name'] ?? 'N/A'}');
          print('');
        }
      }

      if (!foundMatch) {
        print('❌ No users found with phone containing "9828096110"');
      }
    } catch (e) {
      print('⚠️  Error in alternative search: $e');
    }

    print('\n' + '=' * 60);
    print('✅ CHECK COMPLETE');
    print('=' * 60);
  } catch (e, stackTrace) {
    print('\n❌ CRITICAL ERROR: $e');
    print('Stack trace: $stackTrace');
  }
}
